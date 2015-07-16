years = <[ 1980 1990 2001 2011 ]>
class ig.JizakMap extends ig.GenericMap
  (@parentElement) ->
    @mapBounds = L.latLngBounds [50.0061,14.4520] [50.0610,14.5595]
    @mapCenter = [50.0318,14.5071]
    @mapZoom = 14
    super ...

  drawDemography: ->
    objects =
      crs: ig.data.demografie.objects."zsj_demo.geo".crs
      type: ig.data.demografie.objects."zsj_demo.geo".type
      geometries: ig.data.demografie.objects."zsj_demo.geo".geometries.filter -> it.properties.obyv_90 isnt null
    geojson = topojson.feature do
      ig.data.demografie
      objects
    for feature in geojson.features
      feature.properties.demoRatio = feature.properties.obyv_11 / feature.properties.obyv_90
      feature.centroid = d3.geo.centroid feature .reverse!
    colorScale = d3.scale.threshold!
      ..domain [0.8 0.95 1.05 2]
      ..range ['rgb(215,25,28)','rgb(253,174,97)','rgb(255,255,191)','rgb(166,217,106)','rgb(26,150,65)']
    layer = L.geoJson do
      * geojson
      * style: (feature) ->
          color: colorScale feature.properties.demoRatio
          fillOpacity: 0.5
          weight: 2
        onEachFeature: (feature, layer) ~>
          layer.on \mouseover ~> @displayDemoPopup feature, layer
          layer.on \click ~> @displayDemoPopup feature, layer
    @lastHighlightedLayer = null
    layer.addTo @map

  displayDemoPopup: (feature, layer)->
    @lastHighlightedLayer.setStyle weight: 2, fillOpacity: 0.5 if @lastHighlightedLayer
    @lastHighlightedLayer = layer
    layer.setStyle weight: 5, fillOpacity: 0.8
    ele = d3.select document.createElement "div"
    ele.append \b .html feature.properties.NAZ_ZSJ
    pop = for year in <[obyv_80 obyv_90 obyv_01 obyv_11]>
      feature.properties[year]
    ele.append \ul
      ..selectAll \li .data pop .enter!append \li
        ..classed \nan -> it is null
        ..append \span
          ..attr \class \year
          ..html (d, i) -> years[i]
        ..append \span
          ..attr \class \count
          ..html -> ig.utils.formatNumber it
          ..style \bottom -> "#{35 + Math.round it / 100}px"
        ..append \svg
          ..attr \height -> Math.round it / 100
          ..attr \width 40
          ..append \line
            ..attr x1: "50%", x2: "50%", y2: "100%"

    popup = L.popup autoPan: no, className: "demo-popup"
      ..setContent ele.node!
      ..setLatLng feature.centroid
      ..openOn @map
