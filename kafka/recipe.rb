class Kafka < FPM::Cookery::Recipe
  description  'Distributed message broker compiled for Scala 2.9.2 at c12d2ea9e5b4bdcf9aeb07c89c69553a9f270c82'
  homepage     'https://kafka.apache.org/'

  name         'kafka'
  version      '0.8.0'
  revision     4
  arch         'noarch'
  conflicts    'kafka'
  section      'messaging'

  source 'https://github.com/apache/kafka.git',
    with: :git,
    sha: 'c12d2ea9e5b4bdcf9aeb07c89c69553a9f270c82'

  config_files '/etc/kafka/producer.properties',
               '/etc/kafka/consumer.properties',
               '/etc/kafka/log4j.properties'

  maintainer   'Henrik Feldt <henrik@haf.se>'

  def build
    inline_replace 'bin/kafka-server-start.sh' do |s|
      s.gsub! '$base_dir/../config/log4j.properties"', '/etc/kafka/log4j.properties"'
    end
    inline_replace 'bin/kafka-run-class.sh' do |s|
      s.sub! 'exception.txt', '/var/log/kafka/exception.txt'
      s.sub! 'cat exception.txt', 'cat /var/log/kafka/exception.txt'
      s.sub! 'rm exception.txt', 'rm /var/log/kafka/exception.txt'
      s.sub! 'LOG_DIR=$base_dir/logs', 'LOG_DIR=/var/log/kafka'
      s.sub! 'SCALA_VERSION=2.8.0', 'SCALA_VERSION=2.9.2'
      s.sub! 'for file in $base_dir/core', 'for file in /opt/kafka/core'
      s.sub! 'for file in $base_dir/perf', 'for file in /opt/kafka/perf'
      s.sub! 'for file in $base_dir/libs/*.jar;', 'for file in /opt/kafka/libs/*.jar;'
      s.sub! 'for file in $base_dir/kafka*.jar;', 'for file in /opt/kafka/kafka*.jar;'
      s.sub! '$base_dir/config/tools-log4j.properties', '/etc/kafka/tools-log4j.properties'
    end
    safesystem './sbt', '++2.9.2 update'
    safesystem './sbt', '++2.9.2 package'
    safesystem './sbt', '++2.9.2 assembly-package-dependency'
  end

  def install
    %w(lib/kafka log/kafka).each do |dir|
      (var/dir).mkdir
    end

    (etc/'kafka').install Dir['config/*.properties']

    bin.install Dir['bin/kafka-*.sh']

    (opt/'kafka').mkdir

    %w(bin contrib lib project core).each do |dir|
      opt('kafka').install dir
    end
  end
end
