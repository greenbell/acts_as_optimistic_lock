# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = %q{acts_as_optimistic_lock}
  s.version = "0.0.7"
  s.authors = ["Mitsuhiro Shibuya"]
  s.description = %q{Optimistic Locking for Rails ActiveRecord models.}
  s.email = %q{mit.shibuya@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = Dir.glob("{config,lib}/**/*") + %w(MIT-LICENSE README)
  s.homepage = %q{https://github.com/greenbell/acts_as_optimistic_lock}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Optimistic Locking for Rails ActiveRecord models}

  s.add_runtime_dependency     'activerecord', "~> 3.0.0"
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec',        "~> 2.0.0.beta"
  s.add_development_dependency 'factory_girl', "~> 1.3.3"
  s.add_development_dependency 'database_cleaner'
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end

