mods = Dir["src/mods/**/*.jar"]

mods.each { |mod|
  # Remove path
  mod.gsub! /src\/mods\//, ''
  mod.gsub! /1\.7\.10\//, ''
  mod.gsub! /\.jar/, ''

  # Remove Version Numbers
  mod.gsub! /(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/, ''

  # Remove biddly bobs
  mod.gsub! /\s/, ''
  mod.gsub! /-|\.|_/, ''
  mod.gsub! /\(\)/, ''
}

puts mods
