class Supervisor < FPM::Cookery::Recipe
  description 'A client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems'

  name     'python-supervisor'
  version  '3.0b2'
  revision '2'
  homepage 'http://www.supervisord.org/'
  source   'https://github.com/Supervisor/supervisor', :with => :git, :tag => "#{version}"
  arch     'all'
  section  'admin'

  depends        'python', 'python-setuptools', 'python-meld3'

  case ::FPM::Cookery::Facts.target
    when :deb
      config_files '/etc/supervisor/supervisord.conf',
                   '/etc/init/supervisor.conf',
                   '/etc/default/supervisor'
    when :rpm
      config_files '/etc/supervisord.conf',
                   '/etc/init.d/supervisord',
                   '/etc/sysconfig/supervisord'
  end

  def build
    safesystem 'python setup.py build'
  end

  def install
    safesystem "python setup.py install --single-version-externally-managed --root=../../tmp-dest --no-compile"

    lib("python#{python_version}/site-packages/supervisor").install workdir('cache/supervisor/supervisor/version.txt') # kludge

    etc('supervisor/conf.d').mkdir
    case ::FPM::Cookery::Facts.target
    when :deb
      etc('supervisor').install workdir('supervisord.conf')
      etc('init').install workdir('supervisor.init'), 'supervisor.conf'
      etc('default').install workdir('supervisor.default'), 'supervisor'
    when :rpm
      etc.install workdir('supervisord.conf')

      etc('init.d').install workdir('supervisord'), 'supervisord'
      chmod 0755, etc('init.d/supervisord')

      etc('sysconfig').mkdir
      File.open(etc('sysconfig/supervisord'), 'w') do |io|
        io.write "OPTIONS=\"-c /etc/supervisord.conf\""
      end
    end

    var('run/supervisor').mkdir
    var('log/supervisor').mkdir
  end

  def python_version
    `rpm -q python` =~ /python-(\d\.\d)/
    $1
  end
end

