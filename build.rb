require 'yaml'
require 'nokogiri'

root = YAML::load_file(File.join(__dir__, "variants.yml"))
puts root["variants"][0]
exit

width = 3000
height = 2580

def gen_years(xml, first, last)
  start_x = -360
  space_for_year = 120

  (last-first).times do |n|
    x = start_x + n * space_for_year
    year = first + n
    xml.text_('x' => x.to_s) do
      xml.text year.to_s
    end
  end
end

builder = Nokogiri::XML::Builder.new do |xml|
  xml.doc.create_internal_subset(
    'svg',
    "-//W3C//DTD SVG 1.1//EN",
    "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
  )
  xml.svg('xmlns' => 'http://www.w3.org/2000/svg',
          'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
          'width' => width.to_s,
          'height' => height.to_s) do
    xml.title "Elona variant timeline"
    xml.desc <<END
\nTimeline of all Elona variants known to mankind.
END

    xml.g(id: "years") do
      gen_years(xml, 2006, 2018)
    end
  end
end

puts builder.to_xml
