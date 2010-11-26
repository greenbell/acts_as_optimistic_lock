Factory.define :unversioned, :class => Unversioned do |u|
  u.name 'Unversioned Record'
end

Factory.define :versioned, :class => Versioned do |v|
  v.name 'First Versioned Record'
  v.unversioned { Factory(:unversioned) }
end

Factory.define :revisioned, :class => Revisioned do |r|
  r.name 'Rivisioned Record'
end
