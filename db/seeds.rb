# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
10.times do  
  User.create!(
    name: Faker::Name.unique.first_name,
    email: Faker::Internet.unique.email,
    password: "12345678",
    password_confirmation: "12345678"
  )
end

20.times do |index|    
  Post.create!(
    user: User.offset(rand(User.count)).first,
    kaigo: "解号#{index}",
    kaigo_hurigana: "かいごうふりがな#{index}",
    shikai: "始解#{index}",
    shikai_hurigana: "しかいふりがな#{index}",
    ability: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキス>トテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテテテテテテテテテテテテテ>テテテテテテテテテテテテテテテテテテテテキストテキストテキストテキストテキストテキストテキストキストテキストテキスト#{index}",
    bankai: "卍解#{index}",
    bankai_hurigana: "ばんかいふりがな#{index}",
    bankai_ability: "テキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト#{index}",
    detail: "テキストテキストテキストテキストテキストテキスト#{index}"
  )
end

