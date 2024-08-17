import Foundation

class PunctualizationQuery
{
    private static var punctualizationQueryFormat = """
Sei un professore di italiano e devi inserire la punteggiatura a questo testo senza alterarne il numero di parole e senza riassumerlo. Solo la punteggiatura. Ecco il testo: %@

Per aiutarti, ti invio il contesto da cui deriva il testo sopra: %@
"""
    private let text: String
    private let context: String
    
    init(text: String, context: String) {
        self.text = text
        self.context = context
    }
    
    public func toString() -> String
    {
        return String(format: PunctualizationQuery.punctualizationQueryFormat, self.text, self.context)
    }
    
}

