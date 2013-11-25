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
    # already built
  end

  def install
    # custom service config dir
    etc('sysconfig').mkdir

    # InitV script
    etc('init.d').install workdir('teamcity-server')
    chmod 755, etc('init.d/teamcity-server')

    # data directory
    var/'lib/teamcity-server'.mkdir
    chmod 755, (var/libdir)

    # installation directory
    opt('teamcity-server/conf').mkdir
    opt('teamcity-server').install Dir['{bin,lib,conf,webapps}']

    # log directory
    var('log/teamcity-server').mkdir
  end
end
