//
//  DocumentManager.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import Foundation
import PDFKit

class DocumentManager {
    
    static func extractTextFromPDF(url: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: url) else {
            return nil
        }
        return pdfDocument.string
    }
    
    static func isPDF(url: URL) -> Bool {
        return PDFDocument(url: url) != nil
    }
    
}
