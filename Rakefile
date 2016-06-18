###
# This Rakefile is meant to ease modpack makers with a variety of useful functions including:
#   * listing mods
#   * Gathering permissions
#   * Building separate client and server zips
###
require 'rake/testtask'
require 'rubygems'
require 'net/http'
require 'json'
require 'pp'

task :default => [:test]

# Config
@source_directory = 'src' # The "minecraft root", Without trailing slash

task :install do
  # The Degenerate way to not need a Gemfile
  begin
    require 'zip'
  rescue LoadError
    `gem install rubyzip`
    Gem.refresh
    retry
  end
end

task :list => [:install] do
  @mods = Set.new

  # Dir["#{@source_directory}/mods/**/*.jar"].each { |mod|
  #   # Remove path
  #   mod.gsub! /#{@source_directory}\/mods\//, ''
  #   mod.gsub! /1\.7\.10\//, ''
  #   mod.gsub! /\.jar/, ''
  #
  #   # Remove Version Numbers
  #   mod.gsub! /-.*$/, ''
  #
  #   # Remove [TAGS]
  #   mod.gsub! /\[.*\]\s?/, ''
  #
  #   @mods.add(Mods.find mod)
  # }

  Dir["#{@source_directory}/mods/**/*.jar"].each { |jar_path|
    @mods.add(Mods.find_mod jar_path)
  }

  if Rake.application.top_level_tasks.include? 'list'
    # puts @mods.map {|mod| mod = mod.name}.uniq
  end
end

task :test => [:install] do
  PP.pp Mods.find_mod('src/mods/buildcraft-7.1.16.jar')
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

  def self.find_mod(path_to_jar)
    Zip::File.open(path_to_jar) do |jar_file|
      if (mcmod = jar_file.glob('mcmod.info').first)
      # If there is an mcmod.info
        json = JSON.parse(mcmod.get_input_stream.read.gsub /\n/, '')
        build_mod nested_hash_value json, 'modid'
      else
      # If there isn't an mcmod.info
        puts "#{path_to_jar} does not have an mcmod.info"
      end
    end
  end

  private
  # Due to many inconsistencies with mod naming, this will never be perfect.
  def self.matches(name, entry)
    name = name.gsub(/[^a-zA-Z]/, '').downcase
    entry_name = entry['modName'].gsub(/[^a-zA-Z]/, '').downcase
    entry_shortname = entry['shortName'].gsub(/[^a-zA-Z]/, '').downcase
    return name == entry_name || name == entry_shortname
  end

  def self.build_mod(modid)
    @permissions_hash.each { |entry|
      if entry['modids'].split(',').map(&:strip).include? modid
        return Mod.new(entry['modName'], entry['shortName'], entry['modids'], entry['modAuthors'], entry['modLink'],
                       entry['privateStringPolicy'], entry['privateLicenceLink'],
                       entry['publicStringPolicy'], entry['privateLicenceLink'])
      end
    }
    puts "#{modid} Is not in the database"
    return Mod.new(modid.capitalize)
  end

  def self.nested_hash_value(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=nested_hash_value(a.last,key) }
      r
    end
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
