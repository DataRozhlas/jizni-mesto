L.Icon.Default.imagePath = "https://samizdat.cz/tools/leaflet/images/"
class ig.GenericMap
  (@parentElement) ->
    @map = L.map do
      * @parentElement.node!
      * minZoom: 10
        maxZoom: 18
        zoom: @mapZoom
        center: @mapCenter
        maxBounds: @mapBounds
        scrollWheelZoom: no

    @map.on \moveend ~>
      c = @map.getCenter!
      b = @map.getBounds!
      b1 = [b.getSouthWest!lat, b.getSouthWest!lng]
      b2 = [b.getNorthEast!lat, b.getNorthEast!lng]
      b1 = b1
        .map (.toFixed 4)
        .join ","
      b2 = b2
        .map (.toFixed 4)
        .join ","

    baseLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
      * zIndex: 1
        opacity: 1
        attribution: 'mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

    labelLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_l2/{z}/{x}/{y}.png"
      * zIndex: 3
        opacity: 0.75
    baseLayer.addTo @map
    labelLayer.addTo @map
