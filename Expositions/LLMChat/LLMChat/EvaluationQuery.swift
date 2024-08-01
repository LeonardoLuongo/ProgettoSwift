import Foundation

class EvaluationQuery
{
    private static let evaluationQueryFormat =
"""
    Ecco gli input:
        contesto:
        %@
        
        studente:
        %@

    Mi aspetto come rispota solo ed unicamente il JSON ben formato.
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


