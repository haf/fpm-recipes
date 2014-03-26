class Nginx < FPM::Cookery::Recipe
  description 'a high performance web server and a reverse proxy server'

  name     'nginx'
  version  '1.5.12'
  revision 2
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
    File.open('upstream_hash_patch.sh', 'w+') do |io|
      io.write %Q{
#!/bin/sh
DIR=nginx_upstream_hash
REF=d244537631f5a90891d412047bc6ea8c707402a7
rm -rf $DIR
mkdir -p $DIR
curl -sSL https://github.com/evanmiller/nginx_upstream_hash/archive/${REF}.tar.gz | tar -C $DIR --strip-components=1 -xzf -
(cat <<CHECKSUMS
f187213f7f7971b85e69d3ecd92c4946ef0c4dfa  $DIR/ngx_http_upstream_hash_module.c
ce5d7be015038db1e59204b3f77f57ab6edb89d1  $DIR/README
98f6fc414f1eca368d9186cf97431b64f586ccb3  $DIR/t/nginx.conf
00e5d3202c901bd4b7908cdbe34b62904e034a99  $DIR/t/hashtest.php
98f6fc414f1eca368d9186cf97431b64f586ccb3  $DIR/t/nginx/conf/nginx.conf
1345a88786e3fd36dd648451d9e3c830b971cdbd  $DIR/t/restart.sh
3b6e14f81556cee0e931f4b3eba45f283e534849  $DIR/t/clean.sh
b2dc4577b5608af4760963cd3a5be0b46f74349c  $DIR/CHANGES
ff5466d71a3586b29923b75341fe4f803c60b615  $DIR/CREDITS
a1100617b9445c328072c8ef785e745e8a108313  $DIR/config
CHECKSUMS
)| sha1sum -c
}
    end
    safesystem 'chmod +x ./upstream_hash_patch.sh'
    safesystem './upstream_hash_patch.sh'

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
      '--add-module=nginx_upstream_hash',

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

