import GoogleGenerativeAI
import Foundation

enum LLMUtilsError: Error {
    case runtimeError(String)
}


class LLMUtilis
{
    public static let TEST_ONLY_PUNCTUALIZED_TEXT = ""
    public static let TEST_ONLY_EVALUATED_JSON_STRING = """
{
    "Errors": [
        {
            "Sentence": "La data di nascita di Giulio Cesare è il 23 luglio del 201, nel calendario romano, che sarebbe il 12 luglio del 100 a.C..",
            "Correction": "La data di nascita di Giulio Cesare è il 13 luglio del 101 a.C. o il 12 luglio del 100 a.C.",
            "Reason": "La data di nascita di Cesare è incerta, ma è il 13 luglio del 101 a.C. o il 12 luglio del 100 a.C., non il 23 luglio del 201 a.C."
        },
        {
            "Sentence": "Nacque nel quartire Suburra,",
            "Correction": "Nacque nella Suburra,",
            "Reason": "Il quartiere si chiama Suburra, non quartire."
        },
        {
            "Sentence": "da un'antica e nota famiglia patrizia, la gens Caludia, famiglia discendente dal primo re romano, Romolo.",
            "Correction": "da un'antica e nota famiglia patrizia, la gens Iulia, che, secondo il mito, annoverava tra gli antenati anche il primo e grande re romano, Romolo.",
            "Reason": "La famiglia di Cesare si chiamava gens Iulia, non gens Caludia. Inoltre, è importante specificare che secondo il mito, la gens Iulia discendeva da Romolo."
        },
        {
            "Sentence": "Quest'ultimo è figlio del principe troiano Enea, figlio a sua volta della dea Venere.",
            "Correction": "Romolo, secondo il mito, era discendente da Iulo (o Ascanio), figlio del principe troiano Enea, figlio a sua volta della dea Venere.",
            "Reason": "Romolo non è figlio di Enea, ma è discendente da Iulo (o Ascanio), figlio di Enea. L'ordine genealogico è importante per la comprensione del contesto."
        }
    ],
    "Warnings": [
        {
            "Sentence": "Ma ci sono altre spiegazioni, per esempio, la Storia Augusta suggerisce che il primo Cesare avesse ucciso un elefante in battaglia durante la prima guerra punica, che fosse nato con una folta capigliatura, oppure con occhi di colore celeste particolarmente vivo.",
            "Correction": "La Storia Augusta suggerisce invece altre tre possibili spiegazioni sull'origine del nome: che il primo Cesare avesse ucciso un elefante in battaglia durante la prima guerra punica, che fosse nato con una folta capigliatura, oppure con occhi di colore celeste particolarmente vivo.",
            "Reason": "La frase è un po' confusa, potrebbe essere meglio specificare che la Storia Augusta offre altre tre spiegazioni sull'origine del nome."
        }
    ],
    "Advices": [
        "In generale, la tua risposta è buona, ma devi prestare attenzione ai dettagli. Ad esempio, la data di nascita di Cesare è incerta e non è corretto dire che è il 23 luglio del 201 a.C., perché non è così. Inoltre, è importante specificare che la gens Iulia, secondo il mito, discendeva da Romolo. Il tuo lavoro sarebbe più completo se aggiungessi anche altre informazioni riguardo alla famiglia di Cesare, alla sua carriera politica e militare, e al suo ruolo nella storia di Roma.",
        "Ricorda di utilizzare il lessico specifico quando parli di storia romana. Ad esempio, invece di dire 'quartire', è meglio dire 'quartiere'. Non aver paura di utilizzare termini specifici come 'gens', 'cognomen', 'patrizi', etc. Questo renderà il tuo lavoro più preciso e professionale."
    ],
    "FinalEvaluation": {
        "Grade": "6.5",
        "BriefReason": "L'esposizione è nel complesso pertinente e soddisfacente nei contenuti, che sono organizzati in maniera semplice e lineare. Il lessico utilizzato è semplice e non sempre pertinente. Il lavoro mostra buone conoscenze di base, ma necessita di un maggiore approfondimento e di una migliore organizzazione."
    }
}
"""
    
    public static func addPuntuactionToText(_ text: String) -> String
    {
        // GEMINI CALL
        
        return text
    }
    
    
    public static func evaluate(exposition: String) throws -> Response
    {
        // GEMINI CALL
        
        //
        var response: Response? = nil
        if let jsonData = TEST_ONLY_EVALUATED_JSON_STRING.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                response = try decoder.decode(Response.self, from: jsonData)
            } catch {
                throw LLMUtilsError.runtimeError("Error decoding JSON: \(error)")
            }
        }
        
        return response!
    }
}
