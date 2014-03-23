class TeamcityServer < FPM::Cookery::Recipe
  description 'A RPM package for TeamCity server'
  homepage    'http://devnet.jetbrains.com/community/teamcity'

  name        'teamcity-server'
  version     '8.1.1'
  revision    2
  arch        'x86_64'
  section     'ci'

  source      "http://download-cf.jetbrains.com/teamcity/TeamCity-#{version}.tar.gz"
  sha1        '4151429282668d42a4f0a85a030d0c092cbe6b62'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  depends     'jdk'

  post_install 'post-install'


  def build
    # already built
  end

  def install
    # custom service config dir
    etc('sysconfig').mkdir

    # InitV script
    etc('init.d').install workdir('teamcity-server')
    chmod 0755, etc('init.d/teamcity-server')

    # data directory
    (var/'lib/teamcity-server').mkdir
    chmod 0755, (var/'lib/teamcity-server')

    # installation directory
    opt('teamcity-server/conf').mkdir
    opt('teamcity-server').install Dir['{bin,lib,conf,webapps}']

    # log directory
    var('log/teamcity-server').mkdir
  end
end
