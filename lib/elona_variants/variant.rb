# lib/variant.rb

class ElonaVariants::Variant
  attr_accessor :name, :long_name, :authors, :desc, :info, :releases, :derived_from, :elonaval_page, :website

  def initialize
  end

  def self.from_yaml(yaml)
    variant = ElonaVariants::Variant.new

    variant.name = yaml["name"]
    variant.long_name = yaml["long_name"]
    variant.authors = yaml["authors"]
    variant.desc = yaml["desc"]
    variant.info = yaml["info"]

    if yaml["derived_from"]
      variant.derived_from = {
        name: yaml["derived_from"]["name"],
        version: yaml["derived_from"]["version"]
      }
    end

    variant.releases = yaml["releases"].map { |r| ElonaVariants::Release.from_yaml(r) }

    variant
  end

  def display_name
    @long_name || @name
  end

  def earliest_release
    @releases.first
  end

  def latest_release
    @releases.last
  end
end
