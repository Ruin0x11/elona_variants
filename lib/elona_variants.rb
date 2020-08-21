# lib/elona_variants.rb

module ElonaVariants
  def self.load(file)
    root = YAML::load_file(file)
    variants = root["variants"].map { |v| ElonaVariants::Variant.from_yaml(v) }

    variants
  end

  def self.load_details(file)
    root = YAML::load_file(file)
    details = root["details"].map { |k, v| [k, ElonaVariants::Detail.from_yaml(k, v)] }.to_h

    details
  end
end

require_relative "elona_variants/variant"
require_relative "elona_variants/release"
require_relative "elona_variants/detail"
require_relative "elona_variants/graph"
