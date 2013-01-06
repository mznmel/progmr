# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# populate tags table with default (major) tags

demoUser = User.new
demoUser.username = "Progmr"
demoUser.email = "progmr@progmr.com"
demoUser.password = "demo"
demoUser.password_confirmation = "demo"
demoUser.save

# categories
=begin
for category in [:categoryArticle, :categoryLink, :categoryQuestionOrDiscussion, :categoryExercise]
  c = Category.new
  c.name = (I18n.t category)
  c.save
end
=end
