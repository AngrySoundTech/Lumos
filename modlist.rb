##
# A simple script to generate a list of mods from jars in the directory
# NOTE: This is not meant to be a perfect list until jars are named consitantly
##
def getModsList
  mods = Dir["src/mods/**/*.jar"]
  mods.each { |mod|
    # Remove path
    mod.gsub! /src\/mods\//, ''
    mod.gsub! /1\.7\.10\//, ''
    mod.gsub! /\.jar/, ''

    # Remove Version Numbers
    mod.gsub! /(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)/, ''

    # Remove tags
    mod.gsub! /\[.*\]/, ''

    # Remove biddly bobs
    mod.gsub! /\s/, ''
    mod.gsub! /-|\.|_/, ''
    mod.gsub! /\(\)/, ''

    mod[0] = mod[0].upcase
  }

  mods.sort
end

if __FILE__ == $0
    puts getModsList
end
