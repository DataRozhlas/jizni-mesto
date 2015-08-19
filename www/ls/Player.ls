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
    subtitle: "Profesorka chemie bydlí na Jižním Městě 37 let"
    chapters:
      * time: 0
        title: "Jak jste se dostala do filmu Věry Chytilové Panelstory?"
      * time: 99.56
        title: "Jak vypadalo Jižní Město, když jste se přistěhovala?"
      * time: 151.63
        title: "Nevadilo vám, že tu chyběly obchody?"
      * time: 189.18
        title: "Jak zvládáte dlouhé dojíždění do práce?"
      * time: 317.15
        title: "Je něco, co na Jižním Městě postrádáte, za čím musíte do centra?"
      * time: 357.8
        title: "Jak se na sídlišti změnilo složení obyvatel?"
      * time: 438.5
        title: "Jak se tady žije dnes?"
      * time: 525
        title: "Vadí vám tu vůbec něco?"


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
