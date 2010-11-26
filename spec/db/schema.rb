ActiveRecord::Schema.define(:version => 1) do

  create_table "versioneds", :force => true do |t|
    t.column "name", :string
    t.column "version", :integer
    t.column "unversioned_id", :integer
  end

  create_table "unversioneds", :force => true do |t|
    t.column "name", :string
  end

  create_table "revisioneds", :force => true do |t|
    t.column "name", :string
    t.column "revision", :integer
  end
end
