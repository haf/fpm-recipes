class KafkaRiemannReporter < FPM::Cookery::Recipe
  description  'A collection of gauges and metrics that are fed form the Kafka broker and push their data to Riemann'
  homepage     'https://github.com/pingles/kafka-riemann-reporter'

  name         'kafka-riemann-reporter'
  version      '0.1.0'
  revision     4
  arch         'noarch'
  conflicts    'kafka-riemann-reporter'
  section      'messaging'

  source       'https://github.com/pingles/kafka-riemann-reporter.git'

  maintainer   'Henrik Feldt <henrik@haf.se>'

  def build
    safesystem 'mvn', 'package'
  end

  def install
    (opt/'kafka/lib').install 'target/kafka-riemann-reporter-0.1-SNAPSHOT-jar-with-dependencies.jar'
  end
end
