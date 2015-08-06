data =
  'pisova':
    title: "Petra Píšová"
    subtitle: "Pro život s malými dětmi ideální místo"
    chapters:
      * time: 0
        title: "Lorem ipsum dolor sit amel"
      * time: 20
        title: "Sed quis turpis laoreet"
      * time: 60
        title: "Aenean varius aliquet viverra"
      * time: 120
        title: "Cras ultricies velit vitae"
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

    @audio = @element.append \audio
      ..attr \src \https://samizdat.blob.core.windows.net/zvuky/pisova2.mp3
      ..attr \controls yes
      ..on \timeupdate ~>
        time = @audio.node!currentTime
        lastChapter = null
        for chapter in @datum.chapters
          break if chapter.time > time
          lastChapter := chapter
        @chapters.classed \active -> it is lastChapter
