class ig.DuchodciGraph
  (@parentElement) ->
    sums = [0,0,0]
    count = 0
    for {properties} in ig.data.allGeojson.features
      continue unless properties.poproduktivni_80
      count++
      sums[0] += properties.poproduktivni_80
      sums[1] += properties.poproduktivni_90
      sums[2] += properties.duchod_11_pct
    names = ["1980" "1990" "2011"]
    sums .= map (it, i) ->
      percent: it / count
      name: names[i]
    @parentElement
      ..selectAll \div .data sums .enter!append \div
        ..attr \class \item
        ..append \span
          ..attr \class \name
          ..html (.name)
        ..append \svg
          ..attr \height -> "#{it.percent / 18.581608 * 100}%"
          ..attr \width 50
          ..append \line
            ..attr x1: "50%", x2: "50%", y2: "100%"
        ..append \span
          ..attr \class \count
          ..style \bottom -> "#{it.percent / 18.581608 * 100}%"
          ..html (it, i) ->
              o = "#{ig.utils.formatNumber it.percent, 1} %"
              if i == 2
                o += "<br>důchodců"
              o
