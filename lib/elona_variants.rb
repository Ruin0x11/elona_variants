# lib/elona_variants.rb

module ElonaVariants
  def self.load(file)
    root = YAML::load_file(file)
    variants = root["variants"].map { |v| ElonaVariants::Variant.from_yaml(v) }

    variants
  end
end

require_relative "elona_variants/variant"
require_relative "elona_variants/release"
require_relative "elona_variants/graph"
