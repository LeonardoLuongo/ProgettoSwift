import GoogleGenerativeAI
import Foundation


class EvaluatorModel: Model
{
    private let systemInstructions = [ """
    Uno studente vuole ripetere un argomento per una prova orale, dopo aver studiato da un documento di appunti.
    Voglio che tu valuti la sua interrogazione riportando in formato JSON errori(errors) e avvertenze(warnings), con relative correzioni e consigli migliorativi e voto finale. La tua valutazione deve basarsi quasi esclusivamente sul contesto che ti fornirò (ossia dagli appunti da cui lo studente ha studiato). Qualora il contesto non sia attinente con il contenuto dell'esposizione dello studente, valuta sulla base delle tue conoscenze.

    Errors: sono errori medio-gravi dell'esposizione. Sono date sbagliate, concetti errati e gravi imprecisioni.
    Warnings: sono imprecisioni di cui tener conto. Piccoli errori nell'esposizione, frasi troppo contorte per essere capite, errori grammaticali gravi.
    
    Nota importante: l'esposizione fornita è frutto di una trascrizione speech-to-text, per cui è possibile che vi siano errori di trascrizione. Voglio che tu ignori completamente l'uso di parole sbagliate nell'esposizione, soprattutto quando queste sono molto simili foneticamente a quelle che dovrebbero essere corrette.
        Inoltre, voglio che tu ignori completamente e senza alcuna eccezione gli errori di punteggiatura: essendo una trascrizione da file audio, la punteggiatura non è stata inserita dallo studente, per cui non deve assolutamente essere oggetto di valutazione.

    La valutazione sia per il voto che per il rilevamento di errori si divide in:

    * Completezza, pertinenza, organizzazione:
    voto: 10-8.75
    descrittori:
    L’esposizione deve essere pertinente alla consegna,
    ricca e completa nei contenuti.
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
        \"FinalEvaluation\":{
          \"Grade\":\"\",
          \"BriefReason\":\"\"
        },
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
        ]
    }

    Una frase può essere inserita solo in una delle due categorie (errors, warnings), è impossibile che sia in entrambe. Per questo, valuta bene se la frase è ritenuta errata o è un'imprecisione. Non voglio che la risposta venga tagliata se troppo lunga, per cui, se ci sono troppi errori e correzioni, ignorane alcune, in modo da restituire sempre una risposta completa: è importante che sia sempre indicata la FinalEvaluation con il voto.

    Non essere troppo severo: non soffermarti su qualunque imprecisione e non astenerti dal valutare l'esposizione con voti alti quando lo ritieni opportuno. Ricorda che delle parole sbagliate potrebbero essere frutto di un errore della trascrizione speech-to-text: non considerarli come errori. Inoltre, è del tutto possibile (e anzi, è da augurarsi frequente) che non vi sia alcuna imprecisione o errore in una certa esposizione: non è necessario che debbano essere trovati per forza Warnings o Errors, potrebbero anche non esserci. In questo caso, il voto da attribuire è 10.
""",
"""
Valuta solo il contenuto. IGNORA LA PUNTEGGIATURA.
"""
]
    
    init() throws {
        let metadata = ModelMetadata(
            systemInstruction: ModelContent(
                role: "system",
                parts: [.text(systemInstructions[0]), .text(systemInstructions[1])]
            )
        )
        
        super.init(modelMetadata: metadata)
    }
    
    public func evaluate(context: String, exposition: String) async throws -> Response
    {
        // Let's build the query for GEMINI
        let query = EvaluationQuery(context: context, exposition: exposition)
        
        // Here we'll keep the GEMINI's response
        var responseData:String?
        
        do
        {
            responseData = try await super.getResponse(query: query.toString())
        }
        catch
        {
            throw error
        }
        
        // GEMINI returns unexpected chars sometimes, we don't want them.
        responseData = LLMUtilitis.cleanUpTheJSONString(JSONString: responseData!)
        print(responseData!)
        
        var response: Response? = nil
        var i = 0
        var isCorrectJSON = false
        
        // The JSON decode may fail. Therefore, we will do it 5 times. The approch is simple: we'll try to decode it, if it fails, GEMINI will get the JSON and the associated error, with the request to adjust it. This way is a must, because GEMINI's response is not predictable and we cannot put too much effort in the JSON formatting. There's a function that tries to solve the issue in an algorithmyc way to keep the result reliable. It works so, no worries about it.
        while i < 5
        {
            if let data = responseData
            {
                let fixedData = LLMUtilitis.fixIncompleteJSON(JSONString: data)
                if var jsonData = fixedData.data(using: .utf8)
                {
                    let decoder = JSONDecoder()

                    do
                    {
                        response = try decoder.decode(Response.self, from: jsonData)
                        i = 5
                        isCorrectJSON = true
                    }
                    catch
                    {
                        print("(\(i)/5) Trying to get a correct JSON...")
                        print("JSON: \(responseData!)\nError: \(error)")
                        
                        let metadata = ModelMetadata(
                            systemInstruction:
                                ModelContent(role: "system", parts: [.text("You're the best JSON formatter."), .text("You must return the JSON only.")])
                        )
                        let model = Model(modelMetadata: metadata)
                        
                        responseData = try await model.getResponse(query: "I've got this JSON error: \(error) on this JSON data \(responseData!). Solve those problems.")
                        
                        responseData = LLMUtilitis.cleanUpTheJSONString(JSONString: responseData!)
                        print(responseData!)
                        i += 1
                    }
                }
                else
                {
                    throw Exception(exceptionName: "DecodeData2UTF8", exceptionMessage: "Cannot decode from data to utf8.")
                }
            }
            else
            {
                throw Exception(exceptionName: "InvalidGeminiResponse", exceptionMessage: "Cannot insert punctualization to the text. [responseData is nil]")
            }
        }
        
        
        if !isCorrectJSON
        {
            throw Exception(exceptionName: "JsonTTL", exceptionMessage: "Too many attempts for JSON formatting. Try again.")
        }
        
        return response!
    }
}
