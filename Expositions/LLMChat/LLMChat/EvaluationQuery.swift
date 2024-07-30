import Foundation

class EvaluationQuery
{
    private static let evaluationQueryFormat = """
    Immagina di essere un professore universitario e di star interrogando uno studente.
    Voglio che tu valuti la sua interrogazione riportando in formato JSON errori e warnings, con relative correzioni
    e consigli migliorativi e voto finale.

    La valutazione sia per il voto che per il rilevamento di errori si divide in:

    * Completezza, pertinenza, organizzazione:
    voto: 10-8.75
    descrittori:
    L’esposizione deve essere pertinente alla consegna,
    ricca e completa nei contenuti che sono stati rielaborati in maniera personale.
    L’organizzazione degli argomenti trattati è logica e coerente.

    voto: 8.50-7.75
    descrittori:
    L’esposizione è pertinente alla consegna e completa. L’organizzazione dei contenuti è organica e coerente.

    voto: 7.50- 6.00
    descrittore:
    L’esposizione è nel complesso pertinente e soddisfacente nei contenuti, che sono organizzati in maniera semplice e lineare.

    voto: 5.75-5.00
    descrittore:
    L’esposizione non è del tutto pertinente alla consegna, i contenuti incompleti e organizzati in maniera piuttosto confusa

    voto: inferiore a 5
    descrittore:
    L’esposizione non è pertinente; i contenuti molto lacunosi e non organizzati.


    * Chiarezza e correttezza espositiva, uso del lessico specifico:
    voto: 10-8.5
    descrittore:
    L’esposizione è chiara e corretta, il lessico articolato e ricco di termini specifici.

    voto: 8.50-7.75
    descrittore:
    L’esposizione risulta chiara e corretta. La padronanza del linguaggio, compresi i termini specifici è soddisfacente.

    voto: 7.75- 6.00
    descrittore:
    L’esposizione è abbastanza chiara e corretta, il lessico utilizzato è semplice e non sempre pertinente.

    voto: 5.75-5.00
    descrittore:
    L’esposizione è incerta e non sempre corretta. Il lessico è piuttosto povero e spesso inadeguato.

    voto: inferiore a 5
    descrittore:
    L’esposizione è stentata e scorretta; lessico povero


    * Gestione e rielaborazione delle conoscenze:
    voto: 10-8.5
    descrittore:
    Organizzazione delle conoscenze con attenzione e con metodo,
    sapendo recuperare e riutilizzare al momento opportuno e interpretare secondo una chiave di lettura.

    voto: 8.5-7.75
    descrittore:
    Sa recuperare le conoscenze e riutilizzarle al momento opportuno, dando un suo contributo di base alla interpretazione secondo una chiave di lettura.

    voto: 7.75- 6.00
    descrittore:
    Recupera le conoscenze di base, raccogliendole e organizzandole in maniera appena adeguata.

    voto: 5.75-5.00
    descrittore:
    Organizza le conoscenze in maniera confusa e con scarsi elementi di metodo.

    voto: inferiore a 5
    descrittore:
    Non è in grado di gestire le conoscenze


    mi aspetto che in base a questo tu mi dia un JSON del tipo

    {
        \"Errors\":[
            {
                \"Sentence\": \"\",
                \"Correction\": \"\",
                \"Reason\": \"\"
            },
            {
                \"Sentence\": \"\",
                \"Correction\": \"\",
                \"Reason\": \"\"
            },
            ...
            {}
        ],
        \"Warnings\":[
            {
                \"Sentence\": \"\",
                \"Correction\": \"\",
                \"Reason\": \"\"
            },
            {
                \"Sentence\": \"\",
                \"Correction\": \"\",
                \"Reason\": \"\"
            },
            ...
            {}
        ],
        \"Advices\":[
            \"\", \"\", ..., \"\"
        ],
        "FinalEvaluation":{
          "Grade":"",
          "BriefReason":""
        }
    }

    Ecco gli input:
        contesto:
        %s
        
        studente:
        %s
"""
    private let context: String
    private let exposition: String
    
    init(context: String, exposition: String) {
        self.context = context
        self.exposition = exposition
    }
    
    public func toString() -> String
    {
        return String(format: EvaluationQuery.evaluationQueryFormat, self.context, self.exposition)
    }
}


