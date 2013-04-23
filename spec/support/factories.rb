# coding: utf-8

FactoryGirl.define do
  factory :unversioned, :class => Unversioned do
    name 'Unversioned Record'
  end

  factory :versioned, :class => Versioned do
    name 'Versioned Record'
    unversioned { FactoryGirl.create(:unversioned) }
  end

  factory :revisioned, :class => Revisioned do
    name 'Rivisioned Record'
  end

  factory :locale_ja, :class => LocaleJa do
    name '日本語'
  end
end
