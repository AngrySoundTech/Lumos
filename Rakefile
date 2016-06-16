###
# This Rakefile is meant to ease modpack makers with a variety of useful functions including:
#   * listing mods
#   * Gathering permissions
#   * Building separate client and server zips
#
# Caveats:
#   Mod jars are expected to be named a certain way, with the basic format being mod-version.jar
#   For example:
#     buildcraft-7.1.16.jar
#
#   Additionally, tags are permitted for organization.
#   For example:
#     [THAUMCRAFT] Automagy-1.7.10-0.28.2.jar
#   The [CLIENT] tag is special, and it will prevent the mod from being included in the server distribution
###
require 'rake/testtask'
require 'net/http'
require 'json'

task :default => [:test]

# Config
@source_directory = 'src' # The "minecraft root", Without trailing slash

task :list do
  @mods = Set.new

  Dir["#{@source_directory}/mods/**/*.jar"].each { |mod|
    # Remove path
    mod.gsub! /#{@source_directory}\/mods\//, ''
    mod.gsub! /1\.7\.10\//, ''
    mod.gsub! /\.jar/, ''

    # Remove Version Numbers
    mod.gsub! /-.*$/, ''

    # Remove [TAGS]
    mod.gsub! /\[.*\]\s?/, ''

    @mods.add(Mods.find mod)
  }

  if Rake.application.top_level_tasks.include? 'list'
    puts @mods.map {|mod| mod = mod.name}.uniq
  end
end

task :depends => [:list] do
  # So I don't forget how dependencies work
  puts Mods.find('Balanced Exchange').authors
end

class Mod
  def initialize(name,
                 short_name =      'Unknown',
                 modids =          '',
                 authors_string =  '',
                 link =            'Unknown',
                 private_policy =  'Unknown',
                 private_license = 'Unknown',
                 public_policy =   'Unknown',
                 public_license =  'Unknown')
    @name =  name
    @short_name = short_name
    @modids = modids.split(',').map(&:strip)
    @authors = authors_string.split(',').map(&:strip)
    @link = link
    @private_policy = private_policy
    @private_license = private_license
    @public_policy = public_policy
    @public_license = public_license
  end

  attr_accessor :name, :short_name, :modids, :authors, :link,
                :private_policy, :private_license, :public_policy, :public_license
end

class Mods

  uri = URI('http://legacy.feed-the-beast.com/mods/json')
  response = Net::HTTP.get(uri)
  @permissions_hash = JSON.parse(response)

  def self.find(name)
    @permissions_hash.each { |entry|
      if matches name, entry
        return Mod.new(entry['modName'], entry['shortName'], entry['modids'], entry['modAuthors'], entry['modLink'],
                       entry['privateStringPolicy'], entry['privateLicenceLink'],
                       entry['publicStringPolicy'], entry['privateLicenceLink'])
      end
    }
    return Mod.new(name) # Couldn't find info :(
  end

  private
  # Due to many inconsistencies with mod naming, this will never be perfect.
  def self.matches(name, entry)
    name = name.gsub(/[^a-zA-Z]/, '').downcase
    entry_name = entry['modName'].gsub(/[^a-zA-Z]/, '').downcase
    entry_shortname = entry['shortName'].gsub(/[^a-zA-Z]/, '').downcase
    return name == entry_name || name == entry_shortname
  end
end

# Simple class to color output
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end
