require 'fileutils'
require 'shellwords'

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir(".rails_kicker-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      
    ]
  else
    
  end
end