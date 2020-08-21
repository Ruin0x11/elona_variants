# lib/variant.rb

class ElonaVariants::Variant
  attr_accessor :name, :long_name, :authors, :desc, :info, :releases, :derived_from, :webpage, :elonaval_page, :wikia_page

  def initialize
  end

  def self.from_yaml(yaml)
    variant = ElonaVariants::Variant.new

    variant.name = yaml["name"]
    variant.long_name = yaml["long_name"]
    variant.authors = yaml["authors"]
    variant.desc = yaml["desc"]
    variant.info = yaml["info"]
    variant.webpage = yaml["webpage"]
    variant.elonaval_page = yaml["elonaval_page"]
    variant.wikia_page = yaml["wikia_page"]

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

  def created_on
    @releases.filter_map { |r| r.date }.min
  end

  def last_updated
    @releases.filter_map { |r| r.date }.max
  end

  def latest_version
    @releases.filter_map { |r| r.version }.last
  end

  def wikia_link
    "https://elona.fandom.com/wiki/#{@wikia_page}" if @wikia_page
  end

  def link
    @webpage || wikia_link
  end
end
