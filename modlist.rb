##
# A simple script to generate a list of mods from jars in the directory
#
# NOTE: For this to work correctly, mods MUST be named as follows:
#         [TAG] Name-version.jar
#
#       Here are a few examples:
#         [CLIENT] Armor Chroma-1.2-1.7.10.jar
#         ClimateControl-0.6.beta55.jar
##
def getModsList
  mods = Dir["src/mods/**/*.jar"]
  mods.each { |mod|
    # Remove path
    mod.gsub! /src\/mods\//, ''
    mod.gsub! /1\.7\.10\//, ''
    mod.gsub! /\.jar/, ''

    # Remove Version Numbers
    mod.gsub! /-.*$/, ''

    # Remove [TAGS]
    mod.gsub! /\[.*\]\s?/, ''

    mod[0] = mod[0].upcase
  }

  mods.sort.uniq
end

if __FILE__ == $0
    puts getModsList
end
