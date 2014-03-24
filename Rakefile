require 'bundler/setup'
require 'albacore'
require 'net/ssh'

module RpmDownloader
  class << self
    include ::Albacore::Logging
    def download args
      conf = load_conf args
      prepare! conf
      download! conf
      verify conf
    end

    def load_conf args
      require 'yaml'
      require 'fileutils'
      require 'uri'

      dir = args[:proj]
      spec = YAML.load(File.read(File.join(dir, 'source.yaml')))

      # replace all other values inside the uri_template value
      uri_str = spec.keys.
        reject { |k| k == 'uri_template' }.
        # fold over the rest of the values
        inject spec['uri_template'] do |s, t|

        trace { "replacing #{t} with #{spec[t]}" }
        s.gsub "$#{t}", spec[t]
      end

      uri = URI.parse uri_str
      file_name = File.basename(uri.path)

      OpenStruct.new :uri       => uri,
                     :file_name => file_name,
                     :dir       => File.join(dir, 'pkg'),
                     :file_path => File.join(dir, 'pkg', file_name),
                     :sha1      => spec['sha1'],
                     :spec      => spec
    end

    def prepare! conf
      FileUtils.mkdir_p conf.dir, :verbose => true
    end

    def download! conf
      require 'open-uri'
      return if File.exists? conf.file_path and sha1(conf.file_path) == conf.sha1
      chunk_size = 2**16 # 64 KiB
      File.open conf.file_path, 'wb' do |dest|
        # the following #open is provided by open-uri
        open conf.uri, 'rb' do |http_file|
          until http_file.eof?
            dest.write(http_file.read(chunk_size))
          end
        end
      end
    end

    def sha1 file
      require 'digest/sha1'
      chunk_size = 2**16 # 64 KiB
      hash = Digest::SHA1.new
      File.open file, 'r' do |io|
        until io.eof?
          hash.update(io.read(chunk_size))
        end
      end
      hash.hexdigest
    end

    def verify conf
      sha1sum = sha1 conf.file_path
      raise %{SHA1-sum of download (#{sha1sum}) does not match expected #{conf.sha1}} unless
        sha1sum == conf.sha1
    end
  end
end

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
      system 'fpm-cook --quiet --no-deps'
    end
  end
rescue => e
  $stderr.puts e
  raise "running fpm-cook in '#{dir}' failed"
end

task :all_rpms do ; end

namespace :recipes do
  desc 'download an existing rpm'
  task :download, :proj do |t, args|
    RpmDownloader.download args
  end

  desc 'build the given project'
  task :build, :proj do |t, args|
    raise "missing directory #{args[:proj]}" unless File.directory? args[:proj]
    if File.exists?(File.join(args[:proj], 'source.yaml'))
      RpmDownloader.download args
    elsif File.exists?(File.join(args[:proj], 'recipe.rb'))
      fpm args[:proj]
    else
      raise "neither #{args[:proj]}/{source.yaml,recipe.rb} found!"
    end
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
    sh "scp #{args[:proj]}/pkg/*.rpm deployer@yum:/var/yum/el6/x86_64"

    Net::SSH.start 'yum', 'deployer' do |ssh|
      channel = ssh.open_channel do |ch|
        ch.exec '/usr/bin/createrepo /var/yum/el6/x86_64' do |ch, success|
          raise 'could not execute command' unless success

          # "on_data" is called when the process writes something to stdout
          ch.on_data do |c, data|
            $stdout.print data
          end

          # "on_extended_data" is called when the process writes something to stderr
          ch.on_extended_data do |c, type, data|
            $stderr.print data
          end

          ch.on_close do
            puts 'closing channel to yumrepo'
          end
        end
      end

      channel.wait
    end
  end

end
