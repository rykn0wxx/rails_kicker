require 'fileutils'
require 'shellwords'

def apply_template!
  add_template_repository_to_source_path
  copy_gem_file
  set_application_config

  copy_templates
end

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails_kicker-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/rykn0wxx/rails_kicker.git',
      tempdir
    ].map(&:shellescape).join(' ')
    if (branch = __FILE__[%r{jumpstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end

def rails_5?
  Gem::Requirement.new(">= 5.2.0", "< 6.0.0.beta1").satisfied_by? rails_version
end

def rails_6?
  Gem::Requirement.new(">= 6.0.0.beta1", "< 7").satisfied_by? rails_version
end

def copy_gem_file
  template "Gemfile.tt", force: true
  copy_file "gitignore", ".gitignore", force: true
end

def gemfile_requirement name
  @original_gemfile ||= IO.read('Gemfile')
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*)?.*$/, 1]
  puts req
  puts '***************************'
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
  puts req
end

def set_application_config
  environment 'config.application_name = \'zzz_Kicker_zzz\''
  environment 'config.autoload_paths += Dir["#{config.root}/lib/**/"]'
  environment 'config.generators.javascript_engine = :js'
  environment 'config.generators.assets = false'
  environment 'end'
  environment 'g.system_tests = nil'
  environment 'g.helper_specs false'
  environment 'g.view_specs false'
  environment 'g.controller :test_framework => false, :helper => false, :assets => false'
  environment 'g.helper false'
  environment 'g.javascripts false'
  environment 'g.stylesheets false'
  environment 'g.test_framework nil, fixture: false'
  environment 'config.generators do |g|'
end

def copy_templates
  directory 'app', force: true
  remove_file 'app/assets/stylesheets/application.css'

  directory 'config', force: true
  directory "lib", force: true

  route 'root :to => \'home#index\''
end

apply_template!