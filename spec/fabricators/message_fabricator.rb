Fabricator(:message) do
  content { Faker::StarWars.quote }
  user { Fabricate(:user) }
  room { Fabricate(:room) }
end
