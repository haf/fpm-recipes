class Nginx < FPM::Cookery::Recipe
  description 'a high performance web server and a reverse proxy server'

  name     'nginx'
  version  '1.5.12'
  revision 1
  homepage 'http://nginx.org/'
  source   "http://nginx.org/download/nginx-#{version}.tar.gz"
  sha1     '7b298d4eff54041920c233df5c52ec429af11ccd'



  section 'System Environment/Daemons'

  build_depends 'gcc', 'gcc-c++', 'make', 'pcre-devel', 'zlib-devel', 'openssl-devel'

  # 'yum deplist nginx' yields:
  depends       'openssl', 'glibc', 'zlib', 'pcre', 'libxslt',
                'gd', 'GeoIP', 'libxml2', 'perl', 'bash', 'shadow-utils',
                'initscripts', 'chkconfig'

  #config_files '/etc/nginx/nginx.conf',
  #             '/etc/nginx/mime.types'

  def build
    configure \
      '--with-http_gzip_static_module',
      '--with-http_stub_status_module',
      '--with-http_ssl_module',
      '--with-pcre',
      '--with-file-aio',
      '--with-http_realip_module',
      '--without-http_scgi_module',
      '--without-http_uwsgi_module',
      '--with-http_auth_request_module', # http://nginx.org/en/docs/http/ngx_http_auth_request_module.html
#      '--without-http_fastcgi_module',

      :prefix                     => prefix,

      :user                       => 'nginx',
      :group                      => 'nginx',

      :pid_path                   => '/var/run/nginx.pid',
      :lock_path                  => '/var/lock/subsys/nginx',
      :conf_path                  => '/etc/nginx/nginx.conf',
      :http_log_path              => '/var/log/nginx/access.log',
      :error_log_path             => '/var/log/nginx/error.log',
      :http_proxy_temp_path       => '/var/lib/nginx/tmp/proxy',
      :http_fastcgi_temp_path     => '/var/lib/nginx/tmp/fastcgi',
      :http_client_body_temp_path => '/var/lib/nginx/tmp/client_body'
#      :http_uwsgi_temp_path       => '/var/lib/nginx/tmp/uwsgi',
#      :http_scgi_temp_path        => '/var/lib/nginx/tmp/scgi'

    make
  end

  def install
    # startup script
    etc('init.d').install workdir('init.d.nginx') => 'nginx'
    etc('sysconfig').install workdir('sysconfig.nginx') => 'nginx'

    chmod 0755, etc('init.d/nginx')

    # config files
    (etc/'nginx').install Dir['conf/*']

    # default site
    (var/'www/nginx-default').install Dir['html/*']

    # server
    sbin.install Dir['objs/nginx']

    # man page
    man8.install Dir['objs/nginx.8']
    system 'gzip', man8/'nginx.8'

    # support dirs
    %w( run lock log/nginx lib/nginx ).map do |dir|
      (var/dir).mkpath
    end
  end
end

