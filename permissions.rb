require_relative 'modlist'
require 'net/http'
require 'json'
require 'set'

class ModInfo
  def initialize(name, link="Unknown", public_policy="Unknown", private_policy="Unknown")
    @name = name
    @link = link
    @public_policy = public_policy
    @private_policy = private_policy
  end

  attr_accessor :name, :link, :public_policy, :private_policy
end

class Permissions

  uri = URI('http://legacy.feed-the-beast.com/mods/json')
  response = Net::HTTP.get(uri)
  @permissions_hash = JSON.parse(response)

  def self.get_infos_for (mods)
    permissions = Set.new
    mods.each { |mod|

      # Super Ineffecient but I'm lazy as all hell
      modinfo = nil
      @permissions_hash.each { |entry|
        if clean_word(entry["modName"]) == clean_word(mod)
          modinfo = ModInfo.new(
            entry["modName"],
            entry["modLink"],
            entry["publicStringPolicy"],
            entry["privateStringPolicy"])
          break
        end
      }

      if modinfo
        permissions.add modinfo
      else
        permissions.add ModInfo.new(
          mod
        )
      end
    }
    permissions
  end


  private
  def self.clean_word(word)
    word.gsub(/[^a-zA-Z]/, '').downcase
  end
end


if __FILE__ == $0
  Permissions.get_infos_for(getModsList).each { |modinfo|
    puts "#{modinfo.name} - public: #{modinfo.public_policy}, private: #{modinfo.private_policy}"
  }
end
