import GoogleGenerativeAI
import Foundation

let SYSTEM_INSTRUCTION = [
"""
Sei un professore di italiano e devi inserire la punteggiatura a questo testo senza alterarne il numero di parole e senza riassumerlo. Solo la punteggiatura.
""",
"""
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
        \"FinalEvaluation\":{
          \"Grade\":\"\",
          \"BriefReason\":\"\"
        }
    }
"""
]

enum LLMUtilsError: Error {
    case runtimeError(String)
}

class LLMUtilis
{
    
    private static func buildEvaluationQuery(context: String, exposition: String) -> String
    {
        return EvaluationQuery(context: context, exposition: exposition).toString()
    }
    
    private static func buildPunctualizationQuery(text: String) -> String
    {
        return PunctualizationQuery(text: text).toString()
    }
    
    private static func geminiCall(query: String, systemInstruction: ModelContent? = nil) async throws -> String?
    {
        // [START text_gen_text_only_prompt_streaming]
        let generativeModel =
          GenerativeModel(
            // Specify a Gemini model appropriate for your use case
            name: "gemini-1.5-flash",
            // Access your API key from your on-demand resource .plist file (see "Set up your API key"
            // above)
            apiKey: APIKey.default,
            safetySettings: [
                SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone),
                SafetySetting(harmCategory: .harassment, threshold: .blockNone),
                SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone),
                SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone)
            ],
            systemInstruction: systemInstruction,
            requestOptions: RequestOptions(timeout: 20_000.0)
          )
        
        var responseData:String? = nil
        // Use streaming with text-only input
        do
        {
            
            for try await response in generativeModel.generateContentStream(query) {
              if let text = response.text {
                  if responseData == nil
                  {
                      responseData = ""
                  }
                  responseData! += text
                  writeDebugLog("Got a piece of the total response.")
              }
            }
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        // [END text_gen_text_only_prompt_streaming]
        
        return responseData
    }
    
    public static func addPuntuactionToText(_ text: String) async throws -> String
    {
        let query = PunctualizationQuery(text: text)
        var retVal: String? = nil
        do
        {
            retVal = try await LLMUtilis.geminiCall(query: query.toString(), systemInstruction: ModelContent(role: "system", parts: [.text(SYSTEM_INSTRUCTION[0])]))
            
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        if let punctualizedText = retVal
        {
            return punctualizedText
        }
        else
        {
            throw LLMUtilsError.runtimeError("Cannot insert punctualization to the text.")
        }
    }
    
    
    public static func evaluate(context: String, exposition: String) async throws -> Response
    {
        let query = EvaluationQuery(context: context, exposition: exposition)
        var responseData:String?
        do
        {
            if true
            {
                responseData = try await LLMUtilis.geminiCall(query: query.toString(), systemInstruction: ModelContent(role: "system", parts: [.text(SYSTEM_INSTRUCTION[1])]))
                
                print("Formatting the JSON in a better way...")
                
                responseData = try await LLMUtilis.geminiCall(
                    query: "Rendi ben formato questo JSON. Mi aspetto come tua risposta solo il JSON. Ecco quello su cui devi lavorare:\n\(responseData)",
                    systemInstruction: ModelContent(role: "system", parts: [.text("Sei il miglior formattatore JSON esistente.")])
                )
                    
            }
            else
            {
                responseData = RESPONSE
            }
            
            responseData?.replace("´´´", with: "")
            responseData?.replace("json\n", with: "")
            responseData?.replace("```", with: "")
            print(responseData!)
        }
        catch
        {
            throw LLMUtilsError.runtimeError("\(error)")
        }
        
        var response: Response? = nil
        
        if let data = responseData
        {
            if let jsonData = data.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    response = try decoder.decode(Response.self, from: jsonData)
                } catch {
                    throw LLMUtilsError.runtimeError("Error decoding JSON: \(error)")
                }
            }
        }
        
        return response!
    }
}
