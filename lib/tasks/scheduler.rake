desc "This task is called by the Heroku scheduler add-on"
task :clear_old_projects => :environment do
  puts "Clearing old projects..."
  Project.clear_old
  puts "done."
end
