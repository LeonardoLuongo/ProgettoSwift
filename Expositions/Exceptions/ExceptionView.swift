//
//  ExceptionView.swift
//  Expositions
//
//  Created by Studente on 21/08/24.
//

import SwiftUI

struct ExceptionView: View {
    private let exception: Exception
    
    init(exception: Exception) {
        self.exception = exception
    }
    
    var body: some View {
        GeometryReader { metrics in
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text("\(exception.exceptionName)")
                            .padding(.vertical, 10)
                            .font(.largeTitle)
                            .bold()
                        
                        Text("\(exception.exceptionMessage)")
                            .padding(.vertical, 10)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                exception.hasException = false
                            }) {
                                VStack {
                                    Text("Bottone")
                                        .foregroundStyle(Color.white)
                                        .bold()
                                }
                                .frame(width: metrics.size.width * 0.3, height: metrics.size.height * 0.06)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 50)))
                            }
                            
                        }
                    }
                    .padding(.all, 20)
                    .frame(width: metrics.size.width * 0.9, height: metrics.size.height * 0.9)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 10, y: 15.0)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .background(Color.black.opacity(0.4))
        }
    }
}

#Preview {
    ExceptionView(exception: Exception(exceptionName: "Nome eccezione", exceptionMessage: "Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione. Testo eccezione."))
}
