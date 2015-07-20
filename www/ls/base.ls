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

  if ig.containers.demografie
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.JizakMap mapContainer, 'jizak'
      ..drawDemography!

  if ig.containers['demografie-all']
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.JizakMap mapContainer
      ..drawDemography01!

  if ig.containers['byty']
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.JizakMap mapContainer
      ..drawByty!

  if ig.containers['dochod']
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.DochodMap mapContainer
      ..draw!

  if ig.containers['duchodci']
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.JizakMap mapContainer
      ..drawDuchodci!


  if ig.containers['cesticky']
    container = d3.select that
    mapContainer = container.append \div
      ..attr \class "ig map"
    new ig.JizakMap mapContainer, 'jizak'
      ..drawCesticky!
