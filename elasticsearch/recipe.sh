#/bin/bash
sha1=76836f2cc03ced37a141b006e581b03dc4d84dda
version=0.90.6
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
