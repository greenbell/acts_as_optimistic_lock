# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'acts_as_optimistic_lock'

Gem::Specification.new do |s|
  s.name = %q{acts_as_optimistic_lock}
  s.version = ::ActsAsOptimisticLock::VERSION
  s.authors = ["Mitsuhiro Shibuya"]
  s.description = %q{Optimistic Locking for Rails ActiveRecord models.}
  s.email = %q{shibuya@lavan7.co.jp}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = Dir.glob("{lib}/**/*") + %w(CHANGELOG MIT-LICENSE README)
  s.homepage = %q{http://git.dev.ist-corp.jp/acts_as_optimistic_lock}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Optimistic Locking for Rails ActiveRecord models}

  s.add_runtime_dependency     'activerecord', ">= 3.0.0"
  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3-ruby', '1.2.5'
  s.add_development_dependency 'mysql',        '2.8.1'
  s.add_development_dependency 'rspec',        '~> 2.0.0.beta'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'database_cleaner', '0.5.2'
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end

