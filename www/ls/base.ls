ig.fit!
window.acceptData = (data) ->
  ig.data = data
  ig.data.allGeojson = topojson.feature do
    ig.data.demografie
    ig.data.demografie.objects."zsj_demo.geo"
  for feature in ig.data.allGeojson.features
    feature.properties.demoRatio = feature.properties.obyv_11 / feature.properties.obyv_90
    feature.properties.demoRatio01 = feature.properties.obyv_11 / feature.properties.obyv_01
    feature.centroid = d3.geo.centroid feature .reverse!

  visualizations =
    * element: ig.containers.demografie
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.JizakMap mapContainer, 'jizak'
          ..drawDemography!
    * element: ig.containers['demografie-all']
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.JizakMap mapContainer
          ..drawDemography01!
    * element: ig.containers['byty']
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.JizakMap mapContainer
          ..drawByty!
    * element: ig.containers['dochod']
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.DochodMap mapContainer
          ..draw!
    * element: ig.containers['duchodci']
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.JizakMap mapContainer
          ..drawDuchodci!
    * element: ig.containers['cesticky']
      init: (container) ->
        mapContainer = container.append \div
          ..attr \class "ig map"
        new ig.JizakMap mapContainer, 'jizak'
          ..drawCesticky!
    * element: ig.containers['duchodci-graph']
      init: (container) ->
        new ig.DuchodciGraph container
  visualizations .= filter (.element)
  recalculateOffsets = ->
    for visualization in visualizations
      visualization.offset = ig.utils.offset visualization.element .top
  visualizationsInUse = visualizations.slice!
  checkScrollPosition = ->
    top = (document.body.scrollTop || document.documentElement.scrollTop) + window.innerHeight || 0
    top += 350
    for index in [visualizationsInUse.length - 1 to 0 by -1]
      visualization = visualizationsInUse[index]
      if visualization.offset <= top
        visualizationsInUse.splice index, 1
        visualization.init do
          d3.select visualization.element
  recalculateOffsets!
  checkScrollPosition!
  setInterval recalculateOffsets, 2000
  timeout = null
  document.addEventListener "scroll", ->
    return if timeout
    timeout := setTimeout do
      ->
        timeout := null
        checkScrollPosition!
      500


if ig.containers['player-pisova']
  new ig.Player (d3.select that), 'pisova'

if ig.containers['player-malanikova']
  new ig.Player (d3.select that), 'malanikova'
if ig.containers['boxes']
  ig.containers['boxes'].innerHTML = ig.boxContent
