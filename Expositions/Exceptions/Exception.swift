//
//  Exception.swift
//  Expositions
//
//  Created by Studente on 21/08/24.
//

import Foundation

class Exception: ObservableObject{
    @Published var exceptionName: String = ""
    @Published var exceptionMessage: String = ""
    @Published var hasException: Bool = true
    
    init(exceptionName: String, exceptionMessage: String) {
        self.exceptionName = exceptionName
        self.exceptionMessage = exceptionMessage
    }
    
}

enum ExceptionType {
    case geminiException
}
