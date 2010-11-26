class Versioned < ActiveRecord::Base
  acts_as_optimistic_lock
  belongs_to :unversioned
end

class Unversioned < ActiveRecord::Base
  has_one :versioned, :autosave => true
end

class Revisioned < ActiveRecord::Base
  acts_as_optimistic_lock :column => 'revision', :message => 'is old'
end
