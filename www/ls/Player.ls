data =
  'pisova':
    title: "Petra Píšová"
    subtitle: "Pro život s malými dětmi je to ideální místo"
    chapters:
      * time: 0
        title: "Proč bydlíte na Jižním Městě?"
      * time: 35.6
        title: "Jak vypadá váš byt, jaké jste provedli úpravy?"
      * time: 81.43
        title: "Čím se Jižní Město liší od jiných čtvrtí?"
      * time: 139
        title: "Jaké jsou na největším sídlišti vztahy mezi lidmi?"
      * time: 198.8
        title: "Byl život na sídlišti v 80. letech jiný než dnes?"
      * time: 274.2
        title: "Jak se vám tedy na Jižním Městě žije?"
  'malanikova':
    title: "Hana Malaníková"
    subtitle: "Na sídlišti vždycky seženete drogy"
    chapters:
      * time: 0
        title: "Lorem ipsum dolor sit amel"
      * time: 20
        title: "Sed quis turpis laoreet"
      * time: 60
        title: "Aenean varius aliquet viverra"
      * time: 120
        title: "Cras ultricies velit vitae"


class ig.Player
  (@parentElement, @id) ->
    @datum = data[@id]
    @element = @parentElement.append \div
      ..datum @datum
    @element
      ..append \img
        ..attr \src "https://samizdat.cz/data/jizni-mesto/www/img/players/#{@id}.png"
      ..append \h2
        ..html (.title)
      ..append \h3
        ..html (.subtitle)
    @chapters = @element.append \ol
      .selectAll \li .data (.chapters) .enter!append \li .append \a
        ..classed \active (d, i) -> i == 0
        ..attr \href \#
        ..append \span
          ..attr \class \title
          ..html (.title)
        ..on \click ~>
          d3.event.preventDefault!
          @audio.node!
            ..currentTime = it.time
            ..play!
    src = if @id == "pisova"
      "https://samizdat.cz/data/jizni-mesto/audio/pisova-edit.mp3"
    else
      "https://samizdat.cz/data/jizni-mesto/audio/malanikova-edit.mp3"
    @audio = @element.append \audio
      ..attr \src src
      ..attr \controls yes
      ..on \timeupdate ~>
        time = @audio.node!currentTime
        lastChapter = null
        for chapter in @datum.chapters
          break if chapter.time > time
          lastChapter := chapter
        @chapters.classed \active -> it is lastChapter
