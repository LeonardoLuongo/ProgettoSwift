//
//  DocumentManager.swift
//  Expositions
//
//  Created by Studente on 22/07/24.
//

import Foundation
import PDFKit

class DocumentManager {
    
    static func extractTextFromPDF(docPath: String) -> String? {
        let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = appDirectory.appendingPathComponent(docPath)
        if let pdf = PDFDocument(url: url) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()
            
            for i in 0 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
            }
            return documentContent.string
        }
        return nil
    }
    
    static func isPDF(url: URL) -> Bool {
        return PDFDocument(url: url) != nil
    }
    
}
