class TeamcityServer < FPM::Cookery::Recipe
  description 'A RPM package for TeamCity server'
  homepage    'http://devnet.jetbrains.com/community/teamcity'

  name        'teamcity-server'
  version     '8.0.5'
  revision    1
  arch        'x86_64'
  section     'ci'

  source      "http://download-ln.jetbrains.com/teamcity/TeamCity-#{version}.tar.gz"
  sha1        '698aeee8e544d210d121d4ac7d90dbbbddf49639'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  depends     'jdk'

  def build
    safesystem 'tar zxf TeamCity-8.0.5.tar.gz'
  end

  def install
    # https://bitbucket.org/haf/puppet-modules/src/60dc2959ed80dd3b238a86bf1da63d0282e05b11/teamcity_server/README.md?at=master
    #opt('teamcity-server').install workdir('logstash.conf.example'), 'logstash.conf'
  end
end
