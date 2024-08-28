//
//  Exception.swift
//  Expositions
//
//  Created by Studente on 21/08/24.
//

import Foundation
import Combine

class Exception: ObservableObject, Error{
    @Published var exceptionName: String = ""
    @Published var exceptionMessage: String = ""
    @Published var hasException: Bool = false
    
    init(exceptionName: String, exceptionMessage: String) {
        self.exceptionName = exceptionName
        self.exceptionMessage = exceptionMessage
    }
    
}

enum ExceptionType {
    case geminiException
}
