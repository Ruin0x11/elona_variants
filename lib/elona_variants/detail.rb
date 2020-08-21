# lib/detail.rb

class ElonaVariants::Detail
  attr_accessor :desc, :features

  def initialize
  end

  def self.from_yaml(variant_name, yaml)
    detail = ElonaVariants::Detail.new

    detail.desc = yaml["desc"]

    if yaml["features"]
      detail.features = yaml["features"].map do |feature|
        links = feature["links"] || []
        images = feature["images"] || []
        images = images.map do |image|
          "https://raw.githubusercontent.com/Ruin0x11/elona_variants/master/data/images/#{variant_name}/#{image}"
        end

        {
          name: feature["name"],
          desc: feature["desc"],
          notes: feature["notes"],
          added_in: feature["added_in"],
          links: links,
          images: images
        }
      end
    end

    detail
  end
end
