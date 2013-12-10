#/bin/bash
sha1=46c056dca238adc8df2a02e77fc4329b3ececdb5
version=0.90.7
filename=elasticsearch-$version.noarch.rpm

if [[ ! -d pkg ]]; then
  mkdir pkg
fi
pushd pkg
if [[ ! -f $filename ]]; then
  curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/$filename
fi
hash=$(openssl sha1 $filename)
if [[ ! "SHA1(${filename})= $sha1" = "${hash}" ]]; then echo "Invalid Hash $hash, expected $sha1" && exit 1 ; fi

popd
