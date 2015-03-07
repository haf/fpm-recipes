class EventStore < FPM::Cookery::Recipe
  description 'The open-source, functional database with Complex Event Processing in JavaScript.'
  homepage    'http://geteventstore.com/'

  name        'eventstore'
  version     '3.0.1'
  revision    2
  arch        'noarch'
  section     'databases'

  source      'http://download.geteventstore.com/binaries/EventStore-OSS-Linux-v3.0.1.tar.gz', :quiet => true
  sha1        'ab1c4d43a28366f123606452d7fdc91fa013e1e6'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  def build
  end

  def install
    (opt/'eventstore').mkdir
    opt('eventstore').install Dir['**/*']
  end
end
