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
      cattr_accessor  :version_column, :version_message

      self.version_column  = options[:column] || 'version'
      self.version_message = options[:message] || 'is not latest'

      class_eval <<-EOV
        include ActsAsOptimisticLock::InstanceMethods

        def acts_as_optimistic_lock_class
          ::#{self.name}
        end

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
        record = self.class.unscoped.lock(true).select(version_column).find(self.id)
        if version != record.version
          errors.add(version_column, version_message)
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
