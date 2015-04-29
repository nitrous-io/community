# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

tutorials = [
  [
    user_id: 1,
    author: "mary",
    slug: "kinder-bueno",
    title: "Kinder bueno",
    content_markdown: "#Is awesome\nChocolates",
    content_html: "<h1>Is awesome</h1>\n<p>Chocolates</p>",
    tag_list: "rails, ruby",
  ],
  [ 
    user_id: 1,
    author: "john",
    slug: "royce-chocolates",
    title: "Royce chocolates",
    content_markdown: "#Tastes good",
    content_html: "<h1>Tastes good</h1>",
    tag_list: "rails, scala",
  ],
]

tutorials.each do |tutorial|
  Tutorial.create(tutorial)
end
