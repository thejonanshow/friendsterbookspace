Fabricator(:room) do
  topic { Faker::Hacker.ingverb.capitalize }
  slug { Faker::Hacker.abbreviation.downcase }
end
