class Logstash < FPM::Cookery::Recipe
  homepage    'http://logstash.net/'
  name        'logstash'
  # 1.2.2 fixes:
  # https://logstash.jira.com/browse/LOGSTASH-1585?jql=project%20%3D%20LOGSTASH%20AND%20affectedVersion%20%3D%20%221.2.2%22%20AND%20status%20in%20%28Resolved%2C%20Closed%29
  version     '1.4.0'
  source      "https://download.elasticsearch.org/logstash/logstash/#{name}-#{version}.tar.gz"
  sha1        '009c9d3d17b781b6ad2cceb776064cda6c6b3957'

  revision    '1'
  maintainer  'Henrik Feldt <henrik@haf.se>'
  license     'Apache 2'
  description 'logstash is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching).'
  arch        'all'
  section     'admin'

  config_files '/etc/logstash/logstash.conf'

  def build
    # install the inputs
    safesystem 'bin/plugin install contrib'
  end

  def install
    # remove windows components
    rm 'bin/logstash.bat'

    etc('logstash').mkdir
    etc('logstash').install workdir('logstash.conf.example'), 'logstash.conf'

    # install everything from the tmp-dest dir in /opt/logstash
    opt('logstash').mkdir
    opt('logstash').install Dir['*']
  end
end

