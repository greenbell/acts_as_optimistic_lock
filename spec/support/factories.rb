# coding: utf-8

Factory.define :unversioned, :class => Unversioned do |u|
  u.name 'Unversioned Record'
end

Factory.define :versioned, :class => Versioned do |v|
  v.name 'Versioned Record'
  v.unversioned { Factory(:unversioned) }
end

Factory.define :revisioned, :class => Revisioned do |r|
  r.name 'Rivisioned Record'
end

Factory.define :locale_ja, :class => LocaleJa do |l|
  l.name '日本語'
end
