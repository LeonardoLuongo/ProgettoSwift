import SwiftUI

let CONTEXT =
"""
Cesare nacque il 13 luglio del 101 o il 12 luglio del 100 a.C. nella Suburra, un quartiere di Roma, da un'antica e nota famiglia patrizia,
        la gens Iulia, che, secondo il mito, annoverava tra gli antenati anche il primo e grande re romano,
        Romolo, e discendeva da Iulo (o Ascanio), figlio del principe troiano Enea, figlio a sua volta della dea Venere.
        Il ramo della gens Iulia che portava il cognomen \"Caesar\" discendeva, secondo il racconto di Plinio il Vecchio,
        da un uomo venuto alla luce in seguito a un parto cesareo (dal verbo latino 'tagliare', caedo, -ĕre, caesus sum, pron. 'kae-do, 'kae-sus sum).
        La Storia Augusta suggerisce invece altre tre possibili spiegazioni sull'origine del nome: che il primo Cesare avesse ucciso un elefante
        (caesai in berbero) in battaglia durante la prima guerra punica, che fosse nato con una folta capigliatura (dal latino caesaries),
        oppure con occhi di colore celeste particolarmente vivo (dal latino oculis caesiis).
"""

let SPEECH =
"""
la data di nascita di Giulio Cesare è il 23 luglio del 201 nel calendario romano che sarebbe il 12 luglio del 100 AC Nacque nel quartire Suburra
        da un antica e nota famiglia patrizia la gens Caludia famiglia discendente dal primo re romano Romolo
        quest ultimo è figlio del principe troiano Enea figlio a sua volta della dea Venere
        secondo il racconto di Plinio il Vecchio il ramo della gens Iulia che portava il cognome Caesar discendeva
        da un uomo venuto alla luce in seguito a un parto cesario dal verbo latino tagliare caedo
        ma ci sono altre spiegazioni per esempio la Storia Augusta suggerisce che il primo Cesare avesse ucciso un elefante
        in battaglia durante la prima guerra punica che fosse nato con una folta capigliatura
        oppure con occhi di colore celeste particolarmente vivo
"""

let PUNCTUALIZED_SPEECH =
"""
La data di nascita di Giulio Cesare è il 23 luglio del 201, nel calendario romano, che sarebbe il 12 luglio del 100 a.C.. Nacque nel quartire Suburra,
        da un'antica e nota famiglia patrizia, la gens Caludia, famiglia discendente dal primo re romano, Romolo.
        Quest'ultimo è figlio del principe troiano Enea, figlio a sua volta della dea Venere.
        Secondo il racconto di Plinio il Vecchio, il ramo della gens Iulia che portava il cognome \"Caesar\" discendeva,
        da un uomo venuto alla luce in seguito a un parto cesario (dal verbo latino 'tagliare', caedo, -ĕre, caesus sum, pron. 'kae-do, 'kae-sus sum).
        Ma ci sono altre spiegazioni, per esempio, la Storia Augusta suggerisce che il primo Cesare avesse ucciso un elefante
        in battaglia durante la prima guerra punica, che fosse nato con una folta capigliatura,
        oppure con occhi di colore celeste particolarmente vivo.
"""

let RESPONSE = ""


/*
let CONTEXT: String = """
I Promessi Sposi è un’opera scritta da Alessandro Manzoni pubblicata per la prima volta nel 1827 e composta da 38 capitoli. Manzoni, per dare più spessore e realismo alla sua opera, non si assunse il merito della sua scrittura ma solo del ritrovamento e della trascrizione di un antico manoscritto contenente fatti accaduti risalenti al ‘600, quando gran parte dell’Italia era sotto il dominio Spagnolo.La storia inizia con Don Abbondio, un prete che deve celebrare il matrimonio fra due giovani, Renzo Tramaglino e Lucia Mondella, mentre sta facendo la sua passeggiata serale. Mentre procede viene fermato da i Bravi, due loschi figuri al servizio di un signore del luogo Don Rodrigo, che esortano il prete a non celebrare le nozze. Infatti, il loro signore ha fatto una scommessa con il cugino Attilio che vedeva Lucia come posta in palio, pertanto vuole impedire le nozze. Don Abbondio accetta e inventa delle scuse per giustificarsi con Renzo che però scopre tutto.La madre di Lucia, Agnese, suggerisce di rivolgersi ad Azzeccagarbugli, un avvocato che inizialmente sembra intenzionato ad aiutare il ragazzo, ma scoperto il coinvolgimento di Don Rodrigo nella faccenda, manda via Renzo. I due innamorati pertanto si rivolgono a Fra Cristoforo, il figlio di un ricco mercante dal cuore d’oro che non ha mai amato le ingiustizie e che, dopo aver ucciso un uomo durante un duello, ha preso i voti. Fra Cristoforo si reca alla residenza di Don Rodrigo per esortarlo a rinunciare ai suoi propositi, ma il signorotto non cambia idea e Fra Cristoforo lo minaccia dicendogli che riceverà la punizione divina. Irritato ed intimorito Don Rodrigo lo caccia in malo modo.Agnese suggerisce ai due giovani un matrimonio a sorpresa, ovvero pronunciare i voti nuziali davanti a un prete e a due testimoni, per ufficializzare l’unione. Sfortunatamente il piano fallisce perché Don Abbondio capisce la situazione ed inizia ad urlare. Intanto Don Rodrigo manda i bravi a rapire Lucia a casa sua ma non la trovano. I due giovani, scoperta la situazione decidono di partire con l’aiuto di Fra Cristoforo che li manda a Milano e a Monza. Lucia viene portata in un convento nei pressi di Monza, gestito da suora Gertrude, una nobile costretta dal padre a prendere i voti ma che presto cederà alle attenzioni di Egidio un giovane poco raccomandabile con cui instaura una torbida relazione che comprenderà anche un omicidio. La monaca ospiterà Lucia nel suo monastero e la giovane racconterà la sua storia alla madre superiora. A Milano è scoppiata una rivolta popolare a causa dell’impressionante aumento del prezzo del pane e Renzo si ritrova coinvolto nel disordine, rischiando di essere arrestato, ma riesce a dileguarsi e a nascondersi a casa di suo cugino Bortolo a Bergamo. Intanto lo zio del conte Attilio fa trasferire Fra Cristoforo a Rimini.Don Rodrigo, scoperta la posizione di Lucia, chiede l’aiuto dell’Innominato, un potentissimo e sanguinario signore, celebre per aver commesso ogni genere di nefandezza, per rapire Lucia. Il rapimento riesce anche grazie all’aiuto di Egidio. La ragazza chiede di essere liberata esortando l’Innominato a redimersi. La notte seguente la ragazza fa voto di castità alla Madonna affinché venga liberata, mentre l’Innominato si pente a seguito dei rimorsi, liberando Lucia la mattina seguente e dandole una dote. Dopo diversi mesi, arriva in Lombardia, e in seguito a Milano, la peste che provoca la morte di moltissima gente. Don Rodrigo si ammala e viene tradito dal capo dei Bravi, Griso, che morirà di peste. Anche Renzo è contagiato ma riesce a guarire e cercherà di ritrovare Lucia nel lazzaretto è nel lazzaretto che si incontrano tutti alla fine. Renzo ritrova Lucia e Fra Cristoforo contagiato e quest’ultimo esorta  Renzo ad abbandonare la sua brama di vendetta verso Don Rodrigo, ormai morente, e libera Lucia dal suo voto. Tornati al loro paese, i due giovani si sposano con Don Abbondio a celebrare le nozze. Finalmente sposi, hanno una figlia che chiameranno Maria, come segno di gratitudine verso la Madonna, e in seguito altri.
"""

let SPEECH: String = """
I promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi insomma non è proprio una lettura da due giorni ma in fondo quale capolavoro lo è quel birbantello di Manzoni per dare più spessore e realismo alla sua opera altrimenti sarebbe stato solo il romanzo di un pischelli ha preferito non spacciarla per propria bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti non ci crede nessuno che risalirebbero al seicento quando gran parte dell'Italia era sotto il dominio spagnolo ma andiamo al sodo cosa succede in questo romanzo tutto inizio su un ramo del lago di Como dove Don Abbondio un prete che ha paura persino di una mosca sta facendo una passeggiata prima di essere fermato dai bravi che in realtà non sono bravi per niente questi due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondello e Renzo tra maglina i nostri due piccioncini protagonisti della storia questo matrimonio non sa da fare i bravi prendono ordini dal loro Bush tale Don Rodrigo Don Rodrigo aveva visto per caso Lucia è incantato dalla sua bellezza che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo Don Abbondio intimorito dei bravi accetta di non sposare Renzo e Lucia corre a casa racconta tutto a perpetua e se ne va a dormire il giorno dopo già pregustando la sua prima notte di nozze Renzo si presenta da Don Abbondio ma quest'ultimo per prendere tempo dice di non sentirsi bene Renzo ragazzo percependo che non riesce a farsi dire da Don Abbondio e perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia come una bestia Renzo va da Lucia che sta già in abito da sposa ti conviene toglierlo e conservarlo cara e insieme annunciano agli invitati che il matrimonio Ciao a tutti e bentornati sull'Erna dopo il successo del nostro favoloso video riassunto sulla Divina Commedia di Dante abbiamo deciso di proseguire la nostra serie sulla letteratura italiana con i promessi sposi capolavoro di Alessandro Manzoni inizia i promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi insomma non è proprio una lettura da due giorni ma in fondo quale capolavoro lo è quel birbantello di Manzoni per dare più spessore e realismo alla sua opera altrimenti sarebbe stato solo il romanzo di un pischelli ha preferito non spacciarla per propria bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti non ci crede nessuno che risalirebbero al seicento quando gran parte dell'Italia era sotto il dominio spagnolo ma andiamo al sodo cosa succede in questo romanzo tutto inizio su un ramo del lago di Como dove Don Abbondio un prete che ha paura persino di una mosca sta facendo una passeggiata prima di essere fermato dai bravi che in realtà non sono bravi per niente questi due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondello e Renzo tra maglina i nostri due piccioncini protagonisti della storia questo matrimonio non sa da fare i bravi prendono ordini dal loro Bush tale Don Rodrigo Don Rodrigo aveva visto per caso Lucia è incantato dalla sua bellezza che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo Don Abbondio intimorito dei bravi accetta di non sposare Renzo e Lucia corre a casa racconta tutto a perpetua e se ne va a dormire il giorno dopo già pregustando la sua prima notte di nozze Renzo si presenta da Don Abbondio ma quest'ultimo per prendere tempo dice di non sentirsi bene Renzo ragazzo percependo che non riesce a farsi dire da Don Abbondio e perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia come una bestia Renzo va da Lucia che sta già in abito da sposa ti conviene toglierlo e conservarlo cara e insieme annunciano agli invitati che il matrimonioPerché il prete è malato che piange è un nero la madre di lei consiglia di rivolgersi ad azzeccagarbugli un avvocato che dovrebbe appunto azzeccare i garbugli ma che invece prima ne crea altri e quando capisce che c'è di mezzo Don Rodrigo si lava le mani e caccia Renzo wow grazie grazie utilissimo ma la laurea l'hai comprata le speranze dei piccioncini sono allora riposte su fra Cristoforo figlio di un ricco mercante dal cuore d'oro che non ha mai amato le ingiustizie e che dopo aver ucciso un uomo durante un duello ha preso i voti fra Cristoforo che non è un pappa molle come Don Abbondio vuole fare il supereroe della situazione e va a parlare con Don Rodrigo per sistemare la questione ma Don Rodrigo non cambia idea e fra Cristoforo lo minaccia dicendogli che riceverà la punizione divina e va via ok utilissimo anche tu insomma fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio dichiarare il loro reciproco amore davanti a un prete e a due testimoni a quanto pare è sufficiente per ufficializzare un matrimonio così Don Abbondio comincia strillare e il piano va a monte nel frattempo si scopre che Don Rodrigo vuole rapire Lucia quindi i due piccioncini decidono che è meglio cambiare aria Renzo se ne va a Milano mentre Lucia e sua madre vanno a Monza ecco che fa quindi la sua comparsa Geltrude ossia la monaca di Monza una suora che di suora ben poco obbligata infatti dal padre a prendere i voti una volta nel monastero se l'è spassata con il depravato Egidio vabbè ma questo è un'altra storia la monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia si farà raccontare un po' di fatti piccanti hai capito Geltrude ma spostiamoci a Milano qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane ma Renzo incurante del pericolo si fa un bel giretto turistico della città inutile dirlo finisce coinvolto nel disordine e provando a fare l'eroe della situazione fa un sacco di casini e rischia anche di farsi arrestare ma siccome il protagonista riesce sempre a svignarsela e si trasferisce dal cugino a Bergamo intanto Don Rodrigo scoperta la posizione di Lucia ricorre alle armi pesanti per riuscire finalmente a rapirla armi pesanti vuol dire un tale di cui non si se il nome vero e quindi chiameremo l'innominato l'innominato con la complicità dell'amante della monaca di Monza riesce a far rapire Lucia Lucia è disperata quindi cosa fa prova a fuggire no fa un voto di castità non si sposerà più se Dio l'aiuterà Ciao a tutti e bentornati sull'Erna dopo il successo del nostro favoloso video riassunto sulla Divina Commedia di Dante abbiamo deciso di proseguire la nostra serie sulla letteratura italiana con i promessi sposi capolavoro di Alessandro Manzoni inizia i promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi insomma non è proprio una lettura da due giorni ma in fondo quale capolavoro lo è quel birbantello di Manzoni per dare più spessore e realismo alla sua opera altrimenti sarebbe stato solo il romanzo di un pischelli ha preferito non spacciarla per propria bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti non ci crede nessuno che risalirebbero al seicento quando gran parte dell'Italia era sotto il dominio spagnolo ma andiamo al sodo cosa succede in questo romanzo tutto inizio su un ramo del lago di Como dove Don Abbondio un prete che ha paura persino di una mosca sta facendo una passeggiata prima di essere fermato dai bravi che in realtà non sono bravi per niente questi due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondello e Renzo tra maglina i nostri due piccioncini protagonisti della storia questo matrimonio non sa da fare i bravi prendono ordini dal loro Bush tale Don Rodrigo Don Rodrigo aveva visto per caso Lucia è incantato dalla sua bellezza che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo Don Abbondio intimorito dei bravi accetta di non sposare Renzo e Lucia corre a casa racconta tutto a perpetua e se ne va a dormire il giorno dopo già pregustando la sua prima notte di nozze Renzo si presenta da Don Abbondio ma quest'ultimo per prendere tempo dice di non sentirsi bene Renzo ragazzo percependo che non riesce a farsi dire da Don Abbondio e perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia come una bestia Renzo va da Lucia che sta già in abito da sposa ti conviene toglierlo e conservarlo cara e insieme annunciano agli invitati che il matrimonioPerché il prete è malato che piange è un nero la madre di lei consiglia di rivolgersi ad azzeccagarbugli un avvocato che dovrebbe appunto azzeccare i garbugli ma che invece prima ne crea altri e quando capisce che c'è di mezzo Don Rodrigo si lava le mani e caccia Renzo wow grazie grazie utilissimo ma la laurea l'hai comprata le speranze dei piccioncini sono allora riposte su fra Cristoforo figlio di un ricco mercante dal cuore d'oro che non ha mai amato le ingiustizie e che dopo aver ucciso un uomo durante un duello ha preso i voti fra Cristoforo che non è un pappa molle come Don Abbondio vuole fare il supereroe della situazione e va a parlare con Don Rodrigo per sistemare la questione ma Don Rodrigo non cambia idea e fra Cristoforo lo minaccia dicendogli che riceverà la punizione divina e va via ok utilissimo anche tu insomma fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio dichiarare il loro reciproco amore davanti a un prete e a due testimoni a quanto pare è sufficiente per ufficializzare un matrimonio così Don Abbondio comincia strillare e il piano va a monte nel frattempo si scopre che Don Rodrigo vuole rapire Lucia quindi i due piccioncini decidono che è meglio cambiare aria Renzo se ne va a Milano mentre Lucia e sua madre vanno a Monza ecco che fa quindi la sua comparsa Geltrude ossia la monaca di Monza una suora che di suora ben poco obbligata infatti dal padre a prendere i voti una volta nel monastero se l'è spassata con il depravato Egidio vabbè ma questo è un'altra storia la monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia si farà raccontare un po' di fatti piccanti hai capito Geltrude ma spostiamoci a Milano qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane ma Renzo incurante del pericolo si fa un bel giretto turistico della città inutile dirlo finisce coinvolto nel disordine e provando a fare l'eroe della situazione fa un sacco di casini e rischia anche di farsi arrestare ma siccome il protagonista riesce sempre a svignarsela e si trasferisce dal cugino a Bergamo intanto Don Rodrigo scoperta la posizione di Lucia ricorre alle armi pesanti per riuscire finalmente a rapirla armi pesanti vuol dire un tale di cui non si se il nome vero e quindi chiameremo l'innominato l'innominato con la complicità dell'amante della monaca di Monza riesce a far rapire Lucia Lucia è disperata quindi cosa fa prova a fuggire no fa un voto di castità non si sposerà più se Dio l'aiuteràA liberarsi ecco quindi che l'innominato che nella sua vita ne ha fatte di tutti i colori inizia a pentirsi e decide non solo di liberare il suo ostaggio ma anche di darle un bel po' di soldi come dote Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia Yeah ma anche la notizia del voto di castità piccola parentesi se vi piacciono le nostre magliette vi ricordiamo che potete acquistarle nel nostro negozio online rendiamo Collection e il link e nella descrizione e così passano diversi mesi e come se tutto questo tran tran non fosse abbastanza a complicare la situazione arriva poi la peste no questa non è la peste tra pustole sofferenza e lazzaretti un sacco di persone si ammalano e qualcuno muore Don Rodrigo si becca la peste e viene trasferito nel lazzaretto anche Renzo è contagiato dalla peste ma sopravvive come Don Abbondio e Lucia ed è proprio nel lazzaretto che si incontrano tutti alla fine Renzo trova Lucia ma non ne vuole proprio sapere di accettare il suo voto fortunatamente per lui viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona wow non so se sia più debole questo voto o le mie braccia quando faccio le flessioni tornate al loro paese i piccioncini si sposano e vivono felici e contenti speriamo davvero che questo riassunto vi abbia aiutato a imparare o perlomeno ripassare il contenuto dei 38 capitoli dei promessi sposi ora se non lo avete già fatto non dimenticate di dare un'occhiata anche al nostro video riassunto sulla Divina Commedia di Dante come sempre trovate i link qui in alto nella card o Giulia e nella descrizione è sempre utile e bello conoscere di cosa parlano i grandi capolavori e i grandi classici della letteratura italiana noi ci rivedremo prestissimo in un altro video sul nostro sito Lernapp.com dove potete trovare tutte le altre lezioni di lingua e cultura italiana o su YouTube oppure non dimenticate di seguire anche l'aire su Facebook Instagram e Twitter a presto stai dicendo ti amo anch'io ti amo Ciao a tutti e bentornati sull'Erna dopo il successo del nostro favoloso video riassunto sulla Divina Commedia di Dante abbiamo deciso di proseguire la nostra serie sulla letteratura italiana con i promessi sposi capolavoro di Alessandro Manzoni inizia i promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi insomma non è proprio una lettura da due giorni ma in fondo quale capolavoro lo è quel birbantello di Manzoni per dare più spessore e realismo alla sua opera altrimenti sarebbe stato solo il romanzo di un pischelli ha preferito non spacciarla per propria bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti non ci crede nessuno che risalirebbero al seicento quando gran parte dell'Italia era sotto il dominio spagnolo ma andiamo al sodo cosa succede in questo romanzo tutto inizio su un ramo del lago di Como dove Don Abbondio un prete che ha paura persino di una mosca sta facendo una passeggiata prima di essere fermato dai bravi che in realtà non sono bravi per niente questi due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondello e Renzo tra maglina i nostri due piccioncini protagonisti della storia questo matrimonio non sa da fare i bravi prendono ordini dal loro Bush tale Don Rodrigo Don Rodrigo aveva visto per caso Lucia è incantato dalla sua bellezza che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo Don Abbondio intimorito dei bravi accetta di non sposare Renzo e Lucia corre a casa racconta tutto a perpetua e se ne va a dormire il giorno dopo già pregustando la sua prima notte di nozze Renzo si presenta da Don Abbondio ma quest'ultimo per prendere tempo dice di non sentirsi bene Renzo ragazzo percependo che non riesce a farsi dire da Don Abbondio e perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia come una bestia Renzo va da Lucia che sta già in abito da sposa ti conviene toglierlo e conservarlo cara e insieme annunciano agli invitati che il matrimonioPerché il prete è malato che piange è un nero la madre di lei consiglia di rivolgersi ad azzeccagarbugli un avvocato che dovrebbe appunto azzeccare i garbugli ma che invece prima ne crea altri e quando capisce che c'è di mezzo Don Rodrigo si lava le mani e caccia Renzo wow grazie grazie utilissimo ma la laurea l'hai comprata le speranze dei piccioncini sono allora riposte su fra Cristoforo figlio di un ricco mercante dal cuore d'oro che non ha mai amato le ingiustizie e che dopo aver ucciso un uomo durante un duello ha preso i voti fra Cristoforo che non è un pappa molle come Don Abbondio vuole fare il supereroe della situazione e va a parlare con Don Rodrigo per sistemare la questione ma Don Rodrigo non cambia idea e fra Cristoforo lo minaccia dicendogli che riceverà la punizione divina e va via ok utilissimo anche tu insomma fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio dichiarare il loro reciproco amore davanti a un prete e a due testimoni a quanto pare è sufficiente per ufficializzare un matrimonio così Don Abbondio comincia strillare e il piano va a monte nel frattempo si scopre che Don Rodrigo vuole rapire Lucia quindi i due piccioncini decidono che è meglio cambiare aria Renzo se ne va a Milano mentre Lucia e sua madre vanno a Monza ecco che fa quindi la sua comparsa Geltrude ossia la monaca di Monza una suora che di suora ben poco obbligata infatti dal padre a prendere i voti una volta nel monastero se l'è spassata con il depravato Egidio vabbè ma questo è un'altra storia la monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia si farà raccontare un po' di fatti piccanti hai capito Geltrude ma spostiamoci a Milano qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane ma Renzo incurante del pericolo si fa un bel giretto turistico della città inutile dirlo finisce coinvolto nel disordine e provando a fare l'eroe della situazione fa un sacco di casini e rischia anche di farsi arrestare ma siccome il protagonista riesce sempre a svignarsela e si trasferisce dal cugino a Bergamo intanto Don Rodrigo scoperta la posizione di Lucia ricorre alle armi pesanti per riuscire finalmente a rapirla armi pesanti vuol dire un tale di cui non si se il nome vero e quindi chiameremo l'innominato l'innominato con la complicità dell'amante della monaca di Monza riesce a far rapire Lucia Lucia è disperata quindi cosa fa prova a fuggire no fa un voto di castità non si sposerà più se Dio l'aiuteràA liberarsi ecco quindi che l'innominato che nella sua vita ne ha fatte di tutti i colori inizia a pentirsi e decide non solo di liberare il suo ostaggio ma anche di darle un bel po' di soldi come dote Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia Yeah ma anche la notizia del voto di castità piccola parentesi se vi piacciono le nostre magliette vi ricordiamo che potete acquistarle nel nostro negozio online rendiamo Collection e il link e nella descrizione e così passano diversi mesi e come se tutto questo tran tran non fosse abbastanza a complicare la situazione arriva poi la peste no questa non è la peste tra pustole sofferenza e lazzaretti un sacco di persone si ammalano e qualcuno muore Don Rodrigo si becca la peste e viene trasferito nel lazzaretto anche Renzo è contagiato dalla peste ma sopravvive come Don Abbondio e Lucia ed è proprio nel lazzaretto che si incontrano tutti alla fine Renzo trova Lucia ma non ne vuole proprio sapere di accettare il suo voto fortunatamente per lui viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona wow non so se sia più debole questo voto o le mie braccia quando faccio le flessioni tornate al loro paese i piccioncini si sposano e vivono felici e contenti
"""

let PUNCTUALIZED_SPEECH: String =
"""
I promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi. Insomma, non è proprio una lettura da due giorni, ma in fondo quale capolavoro lo è? Quel birbantello di Manzoni, per dare più spessore e realismo alla sua opera, altrimenti sarebbe stato solo il romanzo di un "pischelli", ha preferito non spacciarla per propria, bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto. Le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti, non ci crede nessuno, che risalirebbero al Seicento, quando gran parte dell'Italia era sotto il dominio spagnolo. Ma andiamo al sodo, cosa succede in questo romanzo? Tutto inizia su un ramo del lago di Como, dove Don Abbondio, un prete che ha paura persino di una mosca, sta facendo una passeggiata prima di essere fermato dai bravi che, in realtà, non sono bravi per niente. Questi due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondella e Renzo Tramaglina, i nostri due piccioncini protagonisti della storia. Questo matrimonio non sa da fare! I bravi prendono ordini dal loro "Bush", tale Don Rodrigo. Don Rodrigo aveva visto per caso Lucia ed è incantato dalla sua bellezza: che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo. Don Abbondio, intimorito dai bravi, accetta di non sposare Renzo e Lucia corre a casa, racconta tutto a Perpetua e se ne va a dormire il giorno dopo, già pregustando la sua prima notte di nozze. Renzo si presenta da Don Abbondio, ma quest'ultimo, per prendere tempo, dice di non sentirsi bene. Renzo, ragazzo percependo che non riesce a farsi dire da Don Abbondio e Perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia, come una bestia Renzo va da Lucia che sta già in abito da sposa: "Ti conviene toglierlo e conservarlo, cara!" e insieme annunciano agli invitati che il matrimonio... perché il prete è malato, che piange, è un nero. La madre di lei consiglia di rivolgersi ad Azzeccagarbugli, un avvocato che dovrebbe appunto azzeccare i garbugli, ma che invece prima ne crea altri e quando capisce che c'è di mezzo Don Rodrigo, si lava le mani e caccia Renzo. Wow, grazie, grazie, utilissimo, ma la laurea l'hai comprata? Le speranze dei piccioncini sono allora riposte su Fra Cristoforo, figlio di un ricco mercante dal cuore d'oro, che non ha mai amato le ingiustizie e che, dopo aver ucciso un uomo durante un duello, ha preso i voti. Fra Cristoforo, che non è un pappa molle come Don Abbondio, vuole fare il supereroe della situazione e va a parlare con Don Rodrigo per sistemare la questione. Ma Don Rodrigo non cambia idea e Fra Cristoforo lo minaccia, dicendogli che riceverà la punizione divina e va via. Ok, utilissimo anche tu, insomma! Fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio, dichiarare il loro reciproco amore davanti a un prete e a due testimoni, a quanto pare è sufficiente per ufficializzare un matrimonio. Così Don Abbondio comincia a strillare e il piano va a monte. Nel frattempo si scopre che Don Rodrigo vuole rapire Lucia, quindi i due piccioncini decidono che è meglio cambiare aria. Renzo se ne va a Milano, mentre Lucia e sua madre vanno a Monza. Ecco che fa quindi la sua comparsa Gertrude, ossia la Monaca di Monza, una suora che di suora ben poco: obbligata infatti dal padre a prendere i voti, una volta nel monastero se l'è spassata con il depravato Egidio. Vabbè, ma questa è un'altra storia. La Monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia, si farà raccontare un po' di fatti piccanti, hai capito, Geltrude? Ma spostiamoci a Milano, qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane. Ma Renzo, incurante del pericolo, si fa un bel giretto turistico della città. Inutile dirlo, finisce coinvolto nel disordine e provando a fare l'eroe della situazione, fa un sacco di casini e rischia anche di farsi arrestare, ma siccome il protagonista riesce sempre a svignarsela, si trasferisce dal cugino a Bergamo. Intanto Don Rodrigo, scoperta la posizione di Lucia, ricorre alle armi pesanti per riuscire finalmente a rapirla. Armi pesanti vuol dire un tale di cui non si sa il nome vero, e quindi chiameremo "l'Innominato". L'Innominato, con la complicità dell'amante della Monaca di Monza, riesce a far rapire Lucia. Lucia è disperata, quindi cosa fa? Prova a fuggire? No! Fa un voto di castità: non si sposerà più se Dio l'aiuterà... a liberarsi. Ecco quindi che l'Innominato, che nella sua vita ne ha fatte di tutti i colori, inizia a pentirsi e decide non solo di liberare il suo ostaggio, ma anche di darle un bel po' di soldi come dote. Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia. Yeah! Ma anche la notizia del voto di castità. Piccola parentesi: se vi piacciono le nostre magliette, vi ricordiamo che potete acquistarle nel nostro negozio online Rendamo Collection e il link è nella descrizione. E così passano diversi mesi e come se tutto questo tran tran non fosse abbastanza a complicare la situazione, arriva poi la peste. No, questa non è la peste tra pustole, sofferenza e lazzaretti, un sacco di persone si ammalano e qualcuno muore. Don Rodrigo si becca la peste e viene trasferito nel lazzaretto. Anche Renzo è contagiato dalla peste, ma sopravvive, come Don Abbondio e Lucia, ed è proprio nel lazzaretto che si incontrano tutti alla fine. Renzo trova Lucia, ma non ne vuole proprio sapere di accettare il suo voto. Fortunatamente per lui, viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona. Wow, non so se sia più debole questo voto o le mie braccia quando faccio le flessioni. Tornati al loro paese, i piccioncini si sposano e vivono felici e contenti.
"""


let RESPONSE =
"""
```json
{
  "Errors": [
    {
      "Sentence": "I promessi sposi e un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi.",
      "Correction": "I Promessi Sposi è un'opera pubblicata per la prima volta nel 1827 e composta da 38 capitoli, che potrebbero non sembrarti tanti fino a quando non ti accorgi di quanto siano lunghi.",
      "Reason": "Errore di punteggiatura: manca la virgola dopo \"capitoli\"."
    },
    {
      "Sentence": "Quel birbantello di Manzoni, per dare più spessore e realismo alla sua opera, altrimenti sarebbe stato solo il romanzo di un \"pischelli\", ha preferito non spacciarla per propria, bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto.",
      "Correction": "Quel birbantello di Manzoni, per dare più spessore e realismo alla sua opera, altrimenti sarebbe stato solo il romanzo di un \"pischelli\", ha preferito non spacciarla per propria, bensì inventarsi di aver ritrovato un antico manoscritto anonimo e di averlo trascritto. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Le vicende narrate nei promessi sposi sono dunque la trascrizione di eventi realmente accaduti, non ci crede nessuno, che risalirebbero al Seicento, quando gran parte dell'Italia era sotto il dominio spagnolo.",
      "Correction": "Le vicende narrate nei Promessi Sposi sono dunque la trascrizione di eventi realmente accaduti, che risalirebbero al Seicento, quando gran parte dell'Italia era sotto il dominio spagnolo. ",
      "Reason": "Errore di punteggiatura: \"non ci crede nessuno\" è una frase intercalare che necessita di due virgole. Inoltre, manca il punto finale."
    },
    {
      "Sentence": "Questo matrimonio non sa da fare!",
      "Correction": "Questo matrimonio non sa da fare! ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "I bravi prendono ordini dal loro \"Bush\", tale Don Rodrigo.",
      "Correction": "I bravi prendono ordini dal loro \"capo\", tale Don Rodrigo.",
      "Reason": "Errore di lessico: \"Bush\" è un termine inappropriato in questo contesto. Dovrebbe essere sostituito con \"capo\"."
    },
    {
      "Sentence": "Don Rodrigo aveva visto per caso Lucia ed è incantato dalla sua bellezza: che Bonazza aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo.",
      "Correction": "Don Rodrigo aveva visto per caso Lucia ed è incantato dalla sua bellezza: aveva deciso di volerla tutta per sé e dunque impedire il matrimonio con Renzo.",
      "Reason": "Errore di sintassi: \"che Bonazza\" è un'espressione ambigua. Dovrebbe essere sostituita con \"aveva deciso\"."
    },
    {
      "Sentence": "Renzo si presenta da Don Abbondio, ma quest'ultimo, per prendere tempo, dice di non sentirsi bene.",
      "Correction": "Renzo si presenta da Don Abbondio, ma quest'ultimo, per prendere tempo, dice di non sentirsi bene. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Renzo, ragazzo percependo che non riesce a farsi dire da Don Abbondio e Perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia, come una bestia Renzo va da Lucia che sta già in abito da sposa: \"Ti conviene toglierlo e conservarlo, cara!\"",
      "Correction": "Renzo, percependo che non riesce a farsi dire da Don Abbondio e Perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia, come una bestia va da Lucia che sta già in abito da sposa: \"Ti conviene toglierlo e conservarlo, cara!\"",
      "Reason": "Errore di sintassi: la frase è eccessivamente lunga e complessa. Dovrebbe essere divisa in due frasi più semplici. Inoltre, \"ragazzo\" è un'espressione ridondante."
    },
    {
      "Sentence": "e insieme annunciano agli invitati che il matrimonio... perché il prete è malato, che piange, è un nero.",
      "Correction": "e insieme annunciano agli invitati che il matrimonio è stato rinviato perché il prete è malato, che piange, è un nero.",
      "Reason": "Errore di punteggiatura e sintassi: la frase è incompleta e non è chiara. Dovrebbe essere completata con una frase che spieghi il motivo del rinvio del matrimonio."
    },
    {
      "Sentence": "La madre di lei consiglia di rivolgersi ad Azzeccagarbugli, un avvocato che dovrebbe appunto azzeccare i garbugli, ma che invece prima ne crea altri e quando capisce che c'è di mezzo Don Rodrigo, si lava le mani e caccia Renzo.",
      "Correction": "La madre di lei consiglia di rivolgersi ad Azzeccagarbugli, un avvocato che dovrebbe appunto azzeccare i garbugli, ma che invece, quando capisce che c'è di mezzo Don Rodrigo, si lava le mani e caccia Renzo.",
      "Reason": "Errore di punteggiatura: manca la virgola dopo \"garbugli\"."
    },
    {
      "Sentence": "Wow, grazie, grazie, utilissimo, ma la laurea l'hai comprata?",
      "Correction": "Wow, grazie, grazie, utilissimo, ma la laurea l'hai comprata? ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio, dichiarare il loro reciproco amore davanti a un prete e a due testimoni, a quanto pare è sufficiente per ufficializzare un matrimonio.",
      "Correction": "Fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio, dichiarare il loro reciproco amore davanti a un prete e a due testimoni, a quanto pare è sufficiente per ufficializzare un matrimonio. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Così Don Abbondio comincia a strillare e il piano va a monte.",
      "Correction": "Così Don Abbondio comincia a strillare e il piano va a monte. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Nel frattempo si scopre che Don Rodrigo vuole rapire Lucia, quindi i due piccioncini decidono che è meglio cambiare aria.",
      "Correction": "Nel frattempo si scopre che Don Rodrigo vuole rapire Lucia, quindi i due piccioncini decidono che è meglio cambiare aria. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Renzo se ne va a Milano, mentre Lucia e sua madre vanno a Monza.",
      "Correction": "Renzo se ne va a Milano, mentre Lucia e sua madre vanno a Monza. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Ecco che fa quindi la sua comparsa Gertrude, ossia la Monaca di Monza, una suora che di suora ben poco: obbligata infatti dal padre a prendere i voti, una volta nel monastero se l'è spassata con il depravato Egidio.",
      "Correction": "Ecco che fa quindi la sua comparsa Gertrude, ossia la Monaca di Monza, una suora che di suora ben poco: obbligata infatti dal padre a prendere i voti, una volta nel monastero ha avuto una relazione con il depravato Egidio.",
      "Reason": "Errore di lessico e sintassi: \"se l'è spassata\" è un'espressione colloquiale e inappropriata. Dovrebbe essere sostituita con una frase più formale e corretta grammaticalmente."
    },
    {
      "Sentence": "Vabbè, ma questa è un'altra storia.",
      "Correction": "Vabbè, ma questa è un'altra storia. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "La Monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia, si farà raccontare un po' di fatti piccanti, hai capito, Geltrude?",
      "Correction": "La Monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia, si farà raccontare un po' di fatti piccanti, hai capito, Gertrude? ",
      "Reason": "Errore di lessico: il nome della monaca è Gertrude, non Geltrude. Inoltre, manca il punto finale."
    },
    {
      "Sentence": "Ma spostiamoci a Milano, qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane.",
      "Correction": "Ma spostiamoci a Milano, qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Ma Renzo, incurante del pericolo, si fa un bel giretto turistico della città.",
      "Correction": "Ma Renzo, incurante del pericolo, si fa un bel giretto turistico della città. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Inutile dirlo, finisce coinvolto nel disordine e provando a fare l'eroe della situazione, fa un sacco di casini e rischia anche di farsi arrestare, ma siccome il protagonista riesce sempre a svignarsela, si trasferisce dal cugino a Bergamo.",
      "Correction": "Inutile dirlo, finisce coinvolto nel disordine e provando a fare l'eroe della situazione, fa un sacco di casini e rischia anche di farsi arrestare, ma siccome il protagonista riesce sempre a svignarsela, si trasferisce dal cugino a Bergamo. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Intanto Don Rodrigo, scoperta la posizione di Lucia, ricorre alle armi pesanti per riuscire finalmente a rapirla.",
      "Correction": "Intanto Don Rodrigo, scoperta la posizione di Lucia, ricorre alle armi pesanti per riuscire finalmente a rapirla. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Armi pesanti vuol dire un tale di cui non si sa il nome vero, e quindi chiameremo \"l'Innominato\".",
      "Correction": "Armi pesanti vuol dire un tale di cui non si sa il nome vero, e quindi chiameremo \"l'Innominato\". ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "L'Innominato, con la complicità dell'amante della Monaca di Monza, riesce a far rapire Lucia.",
      "Correction": "L'Innominato, con la complicità dell'amante della Monaca di Monza, riesce a far rapire Lucia. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Lucia è disperata, quindi cosa fa? Prova a fuggire? No! Fa un voto di castità: non si sposerà più se Dio l'aiuterà... a liberarsi.",
      "Correction": "Lucia è disperata, quindi cosa fa? Prova a fuggire? No! Fa un voto di castità: non si sposerà più se Dio l'aiuterà a liberarsi.",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Ecco quindi che l'Innominato, che nella sua vita ne ha fatte di tutti i colori, inizia a pentirsi e decide non solo di liberare il suo ostaggio, ma anche di darle un bel po' di soldi come dote.",
      "Correction": "Ecco quindi che l'Innominato, che nella sua vita ne ha fatte di tutti i colori, inizia a pentirsi e decide non solo di liberare il suo ostaggio, ma anche di darle un bel po' di soldi come dote. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia.",
      "Correction": "Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Yeah!",
      "Correction": "",
      "Reason": "Espressione colloquiale e fuori luogo."
    },
    {
      "Sentence": "Ma anche la notizia del voto di castità.",
      "Correction": "Ma anche la notizia del voto di castità. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Piccola parentesi: se vi piacciono le nostre magliette, vi ricordiamo che potete acquistarle nel nostro negozio online Rendamo Collection e il link è nella descrizione.",
      "Correction": "",
      "Reason": "Inserimento di informazioni non pertinenti al contesto dell'analisi."
    },
    {
      "Sentence": "E così passano diversi mesi e come se tutto questo tran tran non fosse abbastanza a complicare la situazione, arriva poi la peste.",
      "Correction": "E così passano diversi mesi e come se tutto questo non fosse abbastanza a complicare la situazione, arriva poi la peste.",
      "Reason": "Errore di lessico: \"tran tran\" è un'espressione colloquiale e inappropriata. Dovrebbe essere sostituita con una frase più formale."
    },
    {
      "Sentence": "No, questa non è la peste tra pustole, sofferenza e lazzaretti, un sacco di persone si ammalano e qualcuno muore.",
      "Correction": "No, questa non è la peste tra pustole, sofferenza e lazzaretti, un sacco di persone si ammalano e qualcuno muore. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Don Rodrigo si becca la peste e viene trasferito nel lazzaretto.",
      "Correction": "Don Rodrigo si becca la peste e viene trasferito nel lazzaretto. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Anche Renzo è contagiato dalla peste, ma sopravvive, come Don Abbondio e Lucia, ed è proprio nel lazzaretto che si incontrano tutti alla fine.",
      "Correction": "Anche Renzo è contagiato dalla peste, ma sopravvive, come Don Abbondio e Lucia, ed è proprio nel lazzaretto che si incontrano tutti alla fine. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Renzo trova Lucia, ma non ne vuole proprio sapere di accettare il suo voto.",
      "Correction": "Renzo trova Lucia, ma non ne vuole proprio sapere di accettare il suo voto. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Fortunatamente per lui, viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona.",
      "Correction": "Fortunatamente per lui, viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    },
    {
      "Sentence": "Wow, non so se sia più debole questo voto o le mie braccia quando faccio le flessioni.",
      "Correction": "",
      "Reason": "Espressione colloquiale e fuori luogo."
    },
    {
      "Sentence": "Tornati al loro paese, i piccioncini si sposano e vivono felici e contenti.",
      "Correction": "Tornati al loro paese, i piccioncini si sposano e vivono felici e contenti. ",
      "Reason": "Errore di punteggiatura: manca il punto finale."
    }
  ],
  "Warnings": [
    {
      "Sentence": "Insomma, non è proprio una lettura da due giorni, ma in fondo quale capolavoro lo è?",
      "Correction": "",
      "Reason": "Frase un po' banale e poco pertinente al contesto."
    },
    {
      "Sentence": "Quei due gli dicono che non deve per nessun motivo al mondo celebrare il matrimonio tra Lucia Mondella e Renzo Tramaglina, i nostri due piccioncini protagonisti della storia.",
      "Correction": "",
      "Reason": "L'utilizzo del termine \"piccioncini\" è un po' infantile e non adatto al contesto."
    },
    {
      "Sentence": "Questo matrimonio non sa da fare!",
      "Correction": "",
      "Reason": "Frase poco precisa e un po' generica."
    },
    {
      "Sentence": "Don Abbondio, intimorito dai bravi, accetta di non sposare Renzo e Lucia corre a casa, racconta tutto a Perpetua e se ne va a dormire il giorno dopo, già pregustando la sua prima notte di nozze.",
      "Correction": "",
      "Reason": "La frase è un po' confusa e non è del tutto chiara la relazione tra le azioni di Lucia e il suo pregustare la prima notte di nozze."
    },
    {
      "Sentence": "Renzo si presenta da Don Abbondio, ma quest'ultimo, per prendere tempo, dice di non sentirsi bene.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene perché Don Abbondio inventi una scusa."
    },
    {
      "Sentence": "Renzo, ragazzo percependo che non riesce a farsi dire da Don Abbondio e Perpetua che Don Rodrigo non vuole che si celebri il matrimonio con Lucia, come una bestia Renzo va da Lucia che sta già in abito da sposa: \"Ti conviene toglierlo e conservarlo, cara!\"",
      "Correction": "",
      "Reason": "L'espressione \"come una bestia\" è un po' fuori luogo e non necessaria."
    },
    {
      "Sentence": "e insieme annunciano agli invitati che il matrimonio... perché il prete è malato, che piange, è un nero.",
      "Correction": "",
      "Reason": "La frase è poco chiara e la spiegazione del rinvio del matrimonio è un po' vaga."
    },
    {
      "Sentence": "Wow, grazie, grazie, utilissimo, ma la laurea l'hai comprata?",
      "Correction": "",
      "Reason": "Frase ironica e non adatta al contesto."
    },
    {
      "Sentence": "Fra quei piccioncini di Renzo e Lucia provano allora a fare un'imboscata a sorpresa a Don Abbondio, dichiarare il loro reciproco amore davanti a un prete e a due testimoni, a quanto pare è sufficiente per ufficializzare un matrimonio.",
      "Correction": "",
      "Reason": "La frase è un po' lunga e complessa."
    },
    {
      "Sentence": "Così Don Abbondio comincia a strillare e il piano va a monte.",
      "Correction": "",
      "Reason": "La frase è poco precisa e non si capisce bene cosa accade."
    },
    {
      "Sentence": "Nel frattempo si scopre che Don Rodrigo vuole rapire Lucia, quindi i due piccioncini decidono che è meglio cambiare aria.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene cosa fanno i due giovani per cambiare aria."
    },
    {
      "Sentence": "Renzo se ne va a Milano, mentre Lucia e sua madre vanno a Monza.",
      "Correction": "",
      "Reason": "La frase è poco precisa e non si capisce bene il motivo del viaggio a Monza."
    },
    {
      "Sentence": "Ecco che fa quindi la sua comparsa Gertrude, ossia la Monaca di Monza, una suora che di suora ben poco: obbligata infatti dal padre a prendere i voti, una volta nel monastero ha avuto una relazione con il depravato Egidio.",
      "Correction": "",
      "Reason": "L'espressione \"di suora ben poco\" è un po' generica e non fornisce informazioni specifiche sulla monaca."
    },
    {
      "Sentence": "Vabbè, ma questa è un'altra storia.",
      "Correction": "",
      "Reason": "Frase generica e poco pertinente al contesto."
    },
    {
      "Sentence": "La Monaca di Monza accetta di ospitare Lucia e la madre nel monastero e una volta rimasta sola con Lucia, si farà raccontare un po' di fatti piccanti, hai capito, Gertrude?",
      "Correction": "",
      "Reason": "La frase è un po' fuori luogo e non si capisce bene cosa significa \"fatti piccanti\"."
    },
    {
      "Sentence": "Ma spostiamoci a Milano, qui è scoppiata una rivolta popolare a causa dell'impressionante aumento del prezzo del pane.",
      "Correction": "",
      "Reason": "La frase è poco precisa e non si capisce bene il ruolo di Renzo nella rivolta."
    },
    {
      "Sentence": "Ma Renzo, incurante del pericolo, si fa un bel giretto turistico della città.",
      "Correction": "",
      "Reason": "La frase è un po' ironica e non si capisce bene se il giretto turistico di Renzo sia reale o una metafora."
    },
    {
      "Sentence": "Inutile dirlo, finisce coinvolto nel disordine e provando a fare l'eroe della situazione, fa un sacco di casini e rischia anche di farsi arrestare, ma siccome il protagonista riesce sempre a svignarsela, si trasferisce dal cugino a Bergamo.",
      "Correction": "",
      "Reason": "La frase è un po' lunga e complessa."
    },
    {
      "Sentence": "Intanto Don Rodrigo, scoperta la posizione di Lucia, ricorre alle armi pesanti per riuscire finalmente a rapirla.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene cosa si intende per \"armi pesanti\"."
    },
    {
      "Sentence": "Armi pesanti vuol dire un tale di cui non si sa il nome vero, e quindi chiameremo \"l'Innominato\".",
      "Correction": "",
      "Reason": "La frase è un po' confusa e non si capisce bene come l'Innominato venga introdotto."
    },
    {
      "Sentence": "L'Innominato, con la complicità dell'amante della Monaca di Monza, riesce a far rapire Lucia.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene il ruolo dell'amante della Monaca di Monza nel rapimento."
    },
    {
      "Sentence": "Lucia è disperata, quindi cosa fa? Prova a fuggire? No! Fa un voto di castità: non si sposerà più se Dio l'aiuterà... a liberarsi.",
      "Correction": "",
      "Reason": "La frase è un po' teatrale e non si capisce bene il contesto del voto di castità."
    },
    {
      "Sentence": "Ecco quindi che l'Innominato, che nella sua vita ne ha fatte di tutti i colori, inizia a pentirsi e decide non solo di liberare il suo ostaggio, ma anche di darle un bel po' di soldi come dote.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene perché l'Innominato si penta e decida di liberare Lucia."
    },
    {
      "Sentence": "Renzo intanto è ancora da suo cugino a Bergamo e riceve metà della dote dalla madre di Lucia.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene come Renzo riceva la metà della dote."
    },
    {
      "Sentence": "Yeah!",
      "Correction": "",
      "Reason": "Espressione colloquiale e fuori luogo."
    },
    {
      "Sentence": "Ma anche la notizia del voto di castità.",
      "Correction": "",
      "Reason": "La frase è poco precisa e non si capisce bene il contesto della notizia."
    },
    {
      "Sentence": "Piccola parentesi: se vi piacciono le nostre magliette, vi ricordiamo che potete acquistarle nel nostro negozio online Rendamo Collection e il link è nella descrizione.",
      "Correction": "",
      "Reason": "Inserimento di informazioni non pertinenti al contesto dell'analisi."
    },
    {
      "Sentence": "E così passano diversi mesi e come se tutto questo non fosse abbastanza a complicare la situazione, arriva poi la peste.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene il ruolo della peste nella storia."
    },
    {
      "Sentence": "No, questa non è la peste tra pustole, sofferenza e lazzaretti, un sacco di persone si ammalano e qualcuno muore.",
      "Correction": "",
      "Reason": "La frase è un po' teatrale e non si capisce bene il contesto della peste."
    },
    {
      "Sentence": "Don Rodrigo si becca la peste e viene trasferito nel lazzaretto.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene cosa accade a Don Rodrigo nel lazzaretto."
    },
    {
      "Sentence": "Anche Renzo è contagiato dalla peste, ma sopravvive, come Don Abbondio e Lucia, ed è proprio nel lazzaretto che si incontrano tutti alla fine.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene il ruolo del lazzaretto nella storia."
    },
    {
      "Sentence": "Renzo trova Lucia, ma non ne vuole proprio sapere di accettare il suo voto.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene il contesto della reazione di Renzo."
    },
    {
      "Sentence": "Fortunatamente per lui, viene sciolto perché non si può fare un voto che includa anche la volontà di un'altra persona.",
      "Correction": "",
      "Reason": "La frase è un po' generica e non si capisce bene il contesto dello scioglimento del voto."
    },
    {
      "Sentence": "Wow, non so se sia più debole questo voto o le mie braccia quando faccio le flessioni.",
      "Correction": "",
      "Reason": "Espressione colloquiale e fuori luogo."
    },
    {
      "Sentence": "Tornati al loro paese, i piccioncini si sposano e vivono felici e contenti.",
      "Correction": "",
      "Reason": "La frase è un po' banale e non si capisce bene il contesto del lieto fine."
    }
  ],
  "Advices": [
    "Utilizza un lessico più formale ed appropriato al contesto. Evita espressioni colloquiali e frasi generiche.",
    "Presta maggiore attenzione alla punteggiatura e alla sintassi. Assicurati che le frasi siano complete e ben strutturate.",
    "Sviluppa un'analisi più profonda della trama e dei personaggi, senza limitarti a riassumere gli eventi."
  ],
  "FinalEvaluation": {
    "Grade": "5.75",
    "BriefReason": "L'esposizione risulta disorganizzata e confusa. La rielaborazione del testo si limita ad un riassunto superficiale e non sempre accurato. Il lessico utilizzato è colloquiale e inadeguato. La comprensione del testo è parziale e si riscontrano errori di punteggiatura e sintassi."
  }
}
```
"""
*/


let DEBUG: Bool = true
func writeDebugLog(_ log: String)
{
    if DEBUG
    {
        print(log)
    }
}

@main
struct HighlightApp: App {
    var body: some Scene {
        WindowGroup {
            LLMChatContentView(context: CONTEXT, speech: SPEECH)
        }
    }
}

struct LLMChatContentView: View {
    let context: String
    let speech: String
    
    @State private var evaluatedSpeech: EvaluatedSpeech? = nil
    @State private var status: String = "Loading..."

    
    var body: some View {
        ScrollView {
            if let evaluatedSpeech = evaluatedSpeech {
                var sentences = evaluatedSpeech.getTextInSentences()
                ForEach(sentences)
                {
                    sentence in
                    LLMChatContentView.sentenceToText(sentence: sentence)
                }
            } else {
                Text(status)
            }
        }
        .onAppear {
            Task {
                await loadSpeechEvaluation()
            }
        }
    }

    // Asynchronous function to load speech evaluation
    func loadSpeechEvaluation() async {
        var singleWords: [SingleWord] = []
        
        for word in speech.split(separator: " ") {
            singleWords.append(SingleWord(text: word + " "))
        }
        
        let rawSpeech = RawSpeech(textInSingleWords: singleWords)
        
        do {
            
            status = "From Raw Text to Punctualized..."
            writeDebugLog("From Raw Text to Punctualized...")
            
            let punctualizedSpeech = try await PunctualizedSpeech(rawSpeech: rawSpeech)
            
            // Test
            // let punctualizedSpeech = PunctualizedSpeech(textInString: PUNCTUALIZED_SPEECH)
            
            status = "From Punctualized to Evaluated..."
            writeDebugLog("From Punctualized to Evaluated...")
            
            let evaluatedSpeech = try await EvaluatedSpeech(context: context, punctualizedText: punctualizedSpeech)
            
            status = "Evaluation Ended."
            writeDebugLog("Evaluation Ended.")
            
            // This part should be tested
            self.evaluatedSpeech = evaluatedSpeech
            
        } catch {
            status = "Error: \(error)"
            print("\(error)")
        }
    }
    
    static func sentenceToText(sentence: Sentence) -> Text
    {
        var attributedString = AttributedString(sentence.getText())
        
        switch sentence.getStatus() {
        case .okay:
            attributedString.backgroundColor = .green
            break
        case .warning:
            attributedString.backgroundColor = .yellow
            break
        case .wrong:
            attributedString.backgroundColor = .red
            break
        }
        return Text(attributedString)
    }
}



#Preview {
    LLMChatContentView(context: CONTEXT, speech: SPEECH)
}
