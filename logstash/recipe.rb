class Logstash < FPM::Cookery::Recipe
  homepage    'http://logstash.net/'
  name        'logstash'
  # 1.2.2 fixes:
  # https://logstash.jira.com/browse/LOGSTASH-1585?jql=project%20%3D%20LOGSTASH%20AND%20affectedVersion%20%3D%20%221.2.2%22%20AND%20status%20in%20%28Resolved%2C%20Closed%29
  version     '1.3.2'
  source      "https://download.elasticsearch.org/logstash/logstash/#{name}-#{version}-flatjar.jar"
  sha1        'd49d48e0a9590eccb3b8acaa368c01f18125f33d'

  revision    '1'
  maintainer  'Henrik Feldt <henrik@haf.se>'
  license     'Apache 2'
  description 'logstash is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching).'
  arch        'all'
  section     'admin'

  config_files '/etc/logstash/logstash.conf'

  def build
  end

  def install
    etc('logstash').install workdir('logstash.conf.example'), 'logstash.conf'
    opt('logstash').install "#{name}-#{version}-flatjar.jar", 'logstash.jar'
  end
end

