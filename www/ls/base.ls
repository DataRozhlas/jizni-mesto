ig.fit!
if ig.containers.demografie
  container = d3.select that
  mapContainer = container.append \div
    ..attr \class "ig map"
  new ig.JizakMap mapContainer
    ..drawDemography!
