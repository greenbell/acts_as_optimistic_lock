I18n.locale = :en

class Versioned < ActiveRecord::Base
  acts_as_optimistic_lock
  belongs_to :unversioned
end

class Unversioned < ActiveRecord::Base
  has_one :versioned, :autosave => true
end

class Revisioned < ActiveRecord::Base
  acts_as_optimistic_lock :column => 'revision', :msg_updated => 'revision is old', :msg_deleted => 'no longer exists'
end

I18n.locale = :ja

class LocaleJa < ActiveRecord::Base
  acts_as_optimistic_lock
end


class Person < ActiveRecord::Base
  acts_as_optimistic_lock
end

class Employer < Person; end
class Employee < Person; end
