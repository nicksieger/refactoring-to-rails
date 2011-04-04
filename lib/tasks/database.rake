namespace :db do
  task "test:prepare" do
    mysql_connect = "mysql -N -u pc --password=pc petclinic"
    output = `echo 'show tables' | #{mysql_connect}`
    fail "mysql failed to connect to petclinic database:\n#{output}" unless $?.success?
    truncate_script = 'SET foreign_key_checks=0;'
    output.chomp.split.each do |table|
      truncate_script << " truncate table #{table};"
    end
    sh "echo '#{truncate_script}' | #{mysql_connect}"
    populate_script = File.expand_path('../../../src/main/resources/db/mysql/populateDB.txt', __FILE__)
    sh "echo '\\. #{populate_script}' | #{mysql_connect}"
  end

  desc "Reset the petclinic database to its original state"
  task :reset => "db:test:prepare"

  desc "Create the petclinic database"
  task :create do
    init_script = File.expand_path('../../../src/main/resources/db/mysql/initDB.txt', __FILE__)
    sh "echo '\\. #{init_script}' | mysql -u root"
  end
end
