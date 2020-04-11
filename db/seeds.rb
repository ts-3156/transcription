# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Request.create(name: 'サンプルデータ 4月10日のインタビュー', created_at: 3.days.ago).tap do |r|
  r.create_audio(filename: '山田さんインタビュー.mp3', codec: 'mp3', duration: 50.minutes)
  t = r.create_transcript(status: 'succeeded', summary: '事業を始めたのは私が30歳の時です。それからは…', character_count: 300)
  t.blob.attach(io: StringIO.new('事業を始めたのは私が30歳の時です。それからは…'), filename: 'output.txt')
end

Request.create(name: 'サンプルデータ 5月10日のミーティング', created_at: 2.days.ago).tap do |r|
  r.create_audio(filename: '新規プロジェクトミーティング.mp3', codec: 'mp3', duration: 30.minutes)
  t = r.create_transcript(status: 'succeeded', summary: '今日からこのメンバーでプロジェクトをスタートします…', character_count: 200)
  t.blob.attach(io: StringIO.new('今日からこのメンバーでプロジェクトをスタートします…'), filename: 'output.txt')
end

Request.create(name: 'サンプルデータ 6月10日のセミナー', created_at: 1.days.ago).tap do |r|
  r.create_audio(filename: 'マーケティング戦略について.mp3', codec: 'mp3', duration: 2.hours)
  t = r.create_transcript(status: 'succeeded', summary: 'この企業が他と違うところは…', character_count: 100)
  t.blob.attach(io: StringIO.new('この企業が他と違うところは…'), filename: 'output.txt')
end
