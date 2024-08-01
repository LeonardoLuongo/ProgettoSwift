import Foundation

class PunctualizationQuery
{
    private static var punctualizationQueryFormat = """
Sei un professore di italiano e devi inserire la punteggiatura a questo testo senza alterarne il numero di parole e senza riassumerlo. Solo la punteggiatura. Ecco il testo:
%@

"""
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    public func toString() -> String
    {
        return String(format: PunctualizationQuery.punctualizationQueryFormat, self.text)
    }
    
}

