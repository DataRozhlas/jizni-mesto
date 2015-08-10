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
          clickable: no
          color: @colorScale feature.properties.dochod_MS
          stroke: no
          opacity: 1
          fillOpacity: 1


    @layer.addTo @map
    @drawLegend!
    {features: @poiFeatures} = topojson.feature ig.data.poi, ig.data.poi.objects['data']
    @updatePoi \dochod_MS

  updatePoi: (type) ->
    typesToProps =
      \dochod_MHD         : "mhd"
      \dochod_MS          : "ms"
      \dochod_ZS          : "zs"
      \dochod_hriste      : "hriste"
      \dochod_potraviny   : "potraviny"
      \dochod_sportoviste : "sportoviste"
    poiType = typesToProps[type]
    features = @poiFeatures.filter -> it.properties.TYP == poiType
    options = color: \#003366 fillOpacity: 0.3 opacity: 0.8, radius: 10
    markers = for feature in features
      marker = L.circleMarker do
        [feature.geometry.coordinates.1, feature.geometry.coordinates.0]
        options
      marker.bindPopup feature.properties.jmeno || "Hřiště"
      marker
    @map.removeLayer @poiGroup if @poiGroup
    @poiGroup = L.layerGroup markers
      ..addTo @map


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
          self.updatePoi value
        ..attr \checked (d, i) -> if i == 0 then "checked" else void
      ..append \label
        ..html -> names[it]
        ..attr \for -> "chc-#it"


