source 'https://rubygems.org'

if ENV['RAILS_VER'] == '3.0'
  gem 'activerecord', '~> 3.0.0'
  gem 'activesupport', '~> 3.0.0'
  gem 'mysql2', '~> 0.2.18'
elsif ENV['RAILS_VER'] == '3.2'
  gem 'activerecord', '~> 3.0'
  gem 'activesupport', '~> 3.0'
  gem 'mysql2'
else
  gem 'activerecord', '~> 4.0'
  gem 'activesupport', '~> 4.0'
  gem 'mysql2'
end
gem 'debugger', platforms: [:mri_19, :mri_20]
gem 'byebug', platforms: :mri_21

gemspec
