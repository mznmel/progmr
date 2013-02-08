namespace :fix_db do
  desc "TODO"
  task :comments_count => :environment do
    Post.all.each do |p|
      p.comments_count = p.comments.count
      p.save
    end
    puts "Done!"
  end

  task :cleanFeatured => :environment do
    Post.update_all :featured => false
    puts "Done!"
  end

  task :cleanSticky => :environment do
    Post.update_all :sticky => false
    puts "Done!"
  end
end
