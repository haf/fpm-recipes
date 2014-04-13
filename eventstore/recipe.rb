class EventStore < FPM::Cookery::Recipe
  description 'The open-source, functional database with Complex Event Processing in JavaScript.'
  homepage    'http://geteventstore.com/'

  name        'eventstore'
  version     '2.0.1'
  revision    2
  arch        'noarch'
  section     'databases'

  source      'http://download.geteventstore.com/binaries/eventstore-mono-2.0.1.tgz', :quiet => true
  sha1        '99744c57fb9930df96424e9ef7c73490e60ab9fb'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  depends     'mono'

  def build
    # just to unzip!
  end

  def install
    (opt/'eventstore').mkdir
    opt('eventstore').install Dir['**/*']
  end
end
