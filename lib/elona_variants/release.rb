# lib/release.rb

class ElonaVariants::Release
  attr_accessor :version, :date, :port_of

  def initialize
  end

  def self.from_yaml(yaml)
    release = ElonaVariants::Release.new

    release.version = yaml["version"] || yaml["date"]

    if yaml["date"]
      release.date = Date.parse(yaml["date"])
    end

    if yaml["port_of"]
      release.port_of = yaml["port_of"].map do |port|
        {
          name: port["name"],
          desc: port["desc"]
        }
      end
    end

    release
  end

  def inspect
    if @date
      "#{@version} (#{@date})"
    else
      "#{@version}"
    end
  end
end
