# Henrik's fpm-recipes

G'dday wanderer. You have searched long and hard for a unified repository that
allows you to build a complete CentOS stack.

You can rest your weary feet now.



```
bundle
# will build from recipe.rb
bundle exec rake recipes:build[nginx] 
# or why not: will download existing rpm from 'sources.yaml'
bundle exec rake recipes:build[elasticsearch]
```

As you understand, you can feed any of the folders into the `build\[ ... \]`
task and have it build automatically. The `Rakefile` takes care of knowing
whether to just download the RPM straight off a source or to build from source.

## License

MIT

## source.yaml files

Example is
[elasticsearch/source.yaml](https://github.com/haf/fpm-recipes/blob/master/elasticsearch/source.yaml)
and reproduced below:

```
---
name:
  'elasticsearch'
version:
  '1.0.1'
sha1:
  'd72bf1cca99ed89291fd0b7b4c6c6a5e0aceeb62'
uri_template:
  'https://download.elasticsearch.org/elasticsearch/elasticsearch/$name-$version.noarch.rpm'
```

The parameters are as follows:

### name

Should be the same name as the folder, which should equal the package name.

### version

The version of the package to download.

### sha1

A sha1 hash, hexdigest-formatted

### uri_template

This is the source from which to download the package. Any settings you have
defined in the yaml file, except this one, will be replaced inside the string.
