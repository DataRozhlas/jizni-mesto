class ig.DochodMap extends ig.GenericMap
  (@parentElement) ->
    @mapBounds = L.latLngBounds [50.0061,14.4520] [50.0610,14.5595]
    @mapCenter = [50.0308,14.51]
    @mapZoom = 15
    super ...

  draw: ->
    geojson = topojson.feature do
      ig.data.dochod
      ig.data.dochod.objects."domy_dochod.geo"

    @colorScale = d3.scale.linear!
      ..domain [2000 832 624 416 0]
      ..range ['rgb(215,25,28)','rgb(215,25,28)','rgb(253,174,97)','rgb(26,150,65)','rgb(26,150,65)']
    @layer = L.geoJson do
      * geojson
      * style: (feature) ~>
          color: @colorScale feature.properties.dochod_MS
          stroke: no
          opacity: 1
          fillOpacity: 1


    @layer.addTo @map
    @drawLegend!

  drawLegend: ->
    names =
      "dochod_MHD": "MHD"
      "dochod_MS": "Mateřské školy"
      "dochod_ZS": "Základní školy"
      "dochod_hriste": "Dětská hřiště"
      "dochod_potraviny": "Potraviny"
      "dochod_sportoviste": "Sportoviště"

    overlays = ["dochod_MS" "dochod_ZS" "dochod_MHD" "dochod_hriste" "dochod_potraviny" "dochod_sportoviste"]
    legend = @parentElement.append \ul
      ..attr \class \legend
    self = @
    legendItems = legend.selectAll \li .data  overlays .enter!append \li
      ..append \input
        ..attr \type \radio
        ..attr \id -> "chc-#it"
        ..attr \name  "chc-layer"
        ..attr \value -> it
        ..on \change ->
          value = @value
          self.layer.setStyle (feature) ->
            color: self.colorScale feature.properties[value]
        ..attr \checked (d, i) -> if i == 0 then "checked" else void
      ..append \label
        ..html -> names[it]
        ..attr \for -> "chc-#it"


