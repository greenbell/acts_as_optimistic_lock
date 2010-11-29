# coding: utf-8

##
# == 概要
# ActiveRecordに楽観的ロック（他で変更されていたら上書きを失敗させる）を実装
#
module ActsAsOptimisticLock
  def self.included(base)
    base.extend(ClassMethods)
  end
  #
  # ActiveRecord::Baseにincludeするモジュール
  #
  module ClassMethods
    def acts_as_optimistic_lock(options = {})
      cattr_accessor  :version_column, :version_message, :deleted_message

      self.version_column  = options[:column] || 'version'
      self.version_message = options[:msg_updated] || I18n.translate('acts_as_optimistic_lock.errors.messages.updated')
      self.deleted_message = options[:msg_deleted] || I18n.translate('acts_as_optimistic_lock.errors.messages.deleted')

      class_eval <<-EOV
        include ActsAsOptimisticLock::InstanceMethods

        before_validation :check_version
        before_save       :increment_version
      EOV
    end
  end
  #
  # 各モデルにincludeされるモジュール
  #
  module InstanceMethods
    #
    # before_validateにフック。DB上のレコードのバージョンと異なっていたらバリデーションを失敗させる
    #
    def check_version
      unless new_record?
        begin
          record = self.class.lock(true).find(self.id)
        rescue ActiveRecord::RecordNotFound
          errors.add :base, deleted_message
          return nil
        end
        if send(version_column) != record.send(version_column)
          self.attributes = record.attributes
          errors.add :base, version_message
          return nil
        end
      end
    end
    #
    # before_saveにフック。保存前にバージョン番号をインクリメント
    #
    def increment_version
      self[version_column] = self[version_column].to_i + 1
    end
  end
end

ActiveRecord::Base.class_eval { include ActsAsOptimisticLock }

Dir[File.join("#{File.dirname(__FILE__)}/../config/locales/*.yml")].each do |locale|
    I18n.load_path.unshift(locale)
end

