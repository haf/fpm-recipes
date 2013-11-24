desc 'display help'
task :default do
  puts 'haf\'s fpm recipes'
  puts `rake -T`
end

task :build do
  FileList['./*'].each do |recipe|
    if File.directory? recipe then
      Dir.chdir recipe do
        system 'fpm-cook' if File.exists? 'recipe.rb'
      end
    end
  end
end
