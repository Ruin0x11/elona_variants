# lib/graph.rb

class ElonaVariants::Graph
  def initialize(variants)
    @variants = variants

    start_y = 50
    @space_for_variant = 50
    @positions = {}

    @space_for_year = 360
    @start = Date.new(2006, 01, 01)

    @y_positions = {}

    @variants.each_with_index do |variant, i|
      pos = {}

      @y_positions[variant.name] = start_y + (i * @space_for_variant)
      variant.releases.each do |release|
        # TODO version_kind
        next unless release.date
        x = discr(release.date)
        pos[release.date] = x
        pos[release.version] = x
      end

      @positions[variant.name] = pos
    end

    @end_year = 2020
    @width = discr(Date.new(@end_year, 06, 01))
    @height = 2580
    @start_x = 0
  end

  def build
    Nokogiri::XML::Builder.new do |svg|
      svg.doc.create_internal_subset(
        'svg',
        "-//W3C//DTD SVG 1.1//EN",
        "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
      )
      svg.svg('xmlns' => 'http://www.w3.org/2000/svg',
              'xmlns:xlink' => 'http://www.w3.org/1999/xlink',
              'width' => @width.to_s,
              'height' => @height.to_s) do
        svg.title "Elona variant timeline"
        svg.desc <<END
\nTimeline of all Elona variants known to mankind.
END

        write_defs(svg)
        write_root(svg)
      end
    end
  end

  private

  def discr(date)
    diff = (date - @start).to_f / 365.0
    return (@space_for_year * diff).round
  end

  def start_pos(variant)
    variant.releases.each do |release|
      if release and release.date
        return discr(release.date)
      end
    end

    nil
  end

  def end_pos(variant)
    variant.releases.reverse.each do |release|
      if release and release.date
        return discr(release.date)
      end
    end

    nil
  end

  def write_years(svg, first, last)
    (last-first).times do |n|
      x = @start_x + n * @space_for_year
      year = first + n
      svg.text_('x' => x.to_s) do
        svg.text year.to_s
      end
    end
  end

  def write_variant(svg, variant)
    x = start_pos(variant)
    return unless x

    svg.g(id: variant.name) do
      svg.a('xlink:href' => "dood") do
        svg.text_(x: x, y: "-15") do
          svg.text variant.name
        end
      end

      derived = variant.derived_from
      if derived
        i = @variants.index { |v| v.name == derived[:name] }
        if i
          dx = if derived[:version]
                 @positions[derived[:name]][derived[:version]]
               end
          dx ||= start_pos(@variants[i])
          dy = @y_positions[@variants[i].name]
          mx = start_pos(variant)
          my = @y_positions[variant.name]
          svg.line(stroke: "#0A0", x1: mx, x2: dx, y1: 0, y2: dy - my)
          svg.circle(stroke: "#0A0", cx: mx, r: "10")
        end
      end

      sp = start_pos(variant)
      ep = end_pos(variant)
      svg.rect(x: sp, y: "-5", width: ep - sp, height: 15, fill: "#AE9A00")

      variant.releases.each do |release|
        next unless release.date
        cx = discr(release.date)
        svg.line(stroke: "black", x1: cx, x2: cx, y1: "-5", y2: "10")
        if release.port_of
          release.port_of.each do |port|
            next unless port[:version]
            tx = if port[:version]
                   @positions[port[:name]][port[:version]]
                 end
            tx ||= cx
            ty = @y_positions[port[:name]] - @y_positions[variant.name]
            svg.line(stroke: "#44F", x1: cx, x2: tx, y1: "-5", y2: ty)
            svg.circle(stroke: "#C00", cx: cx, r: "5")
          end
        end
        if false
          svg.text_(x: cx, y: "5") do
            svg.text release.version or release.date
          end
        end
      end
    end
  end

  def write_content(svg)
    svg.g(id: "content") do
      svg.use(x: "60", y: "20", 'xlink:href' => "#yearlabels")
      svg.use(x: "60", y: "100%", transform: "translate(0, -20)", 'xlink:href' => "#yearlabels")

      @variants.each do |variant|
        svg.use(y: @y_positions[variant.name], 'xlink:href' => "##{variant.name}")
      end
    end
  end

  def write_css(svg)
    svg.style(type: "text/css") do
      svg.cdata <<CDATA
text {
  font-family: "Arial", sans-serif;
  text-align: center;
  color: black;
}

line {
    stroke-linecap:round;
    stroke-width:2px;
}

circle {
    stroke-width:2px;
    fill: white;
}

#yearlabels text {
  font-size: 20px;
  text-anchor: middle;
}

a:hover {
    text-decoration: underline;
}
CDATA
    end
  end

  def write_defs(svg)
    svg.defs do
      write_css(svg)

      svg.pattern(id: "bglines", patternUnits: "userSpaceOnUse", width: @space_for_year.to_s, height: "100%") do
        svg.line(x1: "0", x2: "0", y2: "100%", stroke: "#CCC")
      end

      svg.g(id: "yearlabels") do
        write_years(svg, @start.year, @end_year)
      end

      @variants.each do |variant|
        write_variant(svg, variant)
      end

      write_content(svg)
    end
  end

  def write_root(svg)
    svg.rect(x: "0", y: "0", width: "100%", height: "100%", fill: "#FFFFFF")
    svg.rect(x: "0", y: "0", width: "100%", height: "100%", style: "fill: url(#bglines)")
    svg.use(x: "360", y: "0", 'xlink:href' => "#content")
  end
end
