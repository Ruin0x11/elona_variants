require 'bundler/setup'
$:.unshift File.expand_path('../lib', __FILE__)

# rake console
task :console do
  require "pry"
  require_relative "lib/elona_variants"
  ARGV.clear
  Pry.start
end

# rake build
task :build do
  out = `bin/build_summary`
  File.write("data/variant_overview.md", out)

  graph = `bin/build_graph`
  File.write("data/lineage.svg", graph)
end
