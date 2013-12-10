class EventStoreProjectionsUpgrade < FPM::Cookery::Recipe
  description 'ProjectTool v1 => v2 for: The open-source, functional database with Complex Event Processing in JavaScript.'
  homepage    'http://geteventstore.com/'

  name        'eventstore-projectionsupgrade'
  version     '2.0.1'
  revision    1
  arch        'noarch'
  section     'databases'

  source      'http://download.geteventstore.com/binaries/ProjectionsUpgrade-v1.x-v2.0.0.zip'
  sha1        '606234f099aa8585f43ac583bebc198e2b086dbb'

  maintainer  'Henrik Feldt <henrik@haf.se>'

  def build
    File.open('EventStore.UpgradeProjections', 'w+') do |io|
      io.write %Q{#!/bin/bash
mono /opt/eventstore-projections/EventStore.UpgradeProjections.exe $@
}
    end
    safesystem 'chmod', '+x', 'EventStore.UpgradeProjections'
  end

  def install
    bin.install 'EventStore.UpgradeProjections'
    (opt/'eventstore-projections').mkdir
    (opt/'eventstore-projections').install Dir['*']
  end
end
