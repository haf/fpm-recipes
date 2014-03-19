require 'bundler/setup'
require 'albacore'

require 'net/ssh'

desc 'display help'
task :default do
  puts 'haf\'s fpm recipes'
  puts `rake -T`
end

desc 'build all recipes'
task :build => [:"recipes:mono", :"recipes:fsharp", :"recipes:python_supervisor", :"recipes:teamcity_server"]

def fpm dir
  if File.directory? dir then
    Dir.chdir dir do
      system 'fpm-cook clean'
      shie 'fpm-cook --quiet --no-deps' if File.exists? 'recipe.rb'
    end
  end
rescue e
  puts e
end

task :all_rpms do ; end

namespace :recipes do
  task :build, :proj do |t, args|
    fpm args[:proj]
  end

  task :all_rpms => %w|mono fsharp libgdiplus eventstore python-supervisor teamcity-server nginx|.map { |s| :"build[#{s}]" }
end

namespace :repo do
  desc 'update all remotes, ff if possible'
  task :sync do
    system 'git remote update'
    system 'git pull --ff-only'
  end

  desc 'push all changes'
  task :push do
    system 'git push origin master'
    system 'git push haf master'
  end
end


namespace :rpm do

  desc 'update yum repo with the build project'
  task :update_yum_repo, :proj do |t, args|
    system 'scp', %W| '#{args[:proj]}/pkg/*' deployer@yum:/var/yum/el6/x86_64|

    Net::SSH.start 'yum', 'deployer' do |ssh|
      channel = ssh.open_channel do |ch|
        ch.exec "/usr/bin/createrepo /var/yum/el6/x86_64" do |ch, success|
          raise "could not execute command" unless success

          # "on_data" is called when the process writes something to stdout
          ch.on_data do |c, data|
            $stdout.print data
          end

          # "on_extended_data" is called when the process writes something to stderr
          ch.on_extended_data do |c, type, data|
            $stderr.print data
          end

          ch.on_close do
            puts "/usr/bin/createrepo done!"
          end
        end
      end

      channel.wait
    end
  end

end
