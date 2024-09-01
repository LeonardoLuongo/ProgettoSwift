import SwiftUI

struct IconView: View {
    
    @Binding var selectedSymbol: String
    @Binding var selectedColor: Color
    
    let symbols = ["default","ALGEBRA","ARCHITETTURA","ARITMETICA","ASTRONOMIA","BIOLOGIA","CHIMICA","CINEMA","CINESE","DIRITTO","DISEGNO TECNICO","DIZIONE","ECONOMIA","EDUCAZIONE FISICA","FILOSOFIA","FISICA QUANTISTICA","FISICA","FOTOGRAFIA","GEOGRAFIA","GEOLOGIA","GEOMETRIA","GIAPPONESE","GIURISPRUDENZA","GRAMMATICA ITALIANA","GRECO","INFORMATICA","INGEGNERIA","LATINO","LETTERATURA GRECA","LETTERATURA INGLESE","LETTERATURA ITALIANA","LETTERATURA LATINA","LINGUA INGLESE","LINGUA SPAGNOLA","LINGUA STRANIERA A SCELTA","LINGUA TEDESCA","MECCANICA","MEDICINA","MUSICA","PARAFRASI","PROGETTAZIONE","PSICOLOGIA","RELIGIONE CATTOLICA","SCIENZE NATURALI","SCRITTURA","SOCIOLOGIA","STORIA DELL'ARTE","STORIA","TEATRO"];


    private let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        Text("Your icon:")
        if selectedSymbol == "" {
            Image(uiImage: UIImage(named: "SCRITTURA")!)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
                .foregroundColor(.white)
                .background(selectedColor)
                .frame(width: 50, height: 50)
                .cornerRadius(10)
        } else if selectedSymbol == "default" {
            Rectangle()
                .scaledToFit()
                .foregroundColor(selectedColor)
                .frame(width: 20, height: 20)
                .padding()
                .background(selectedColor)
                .cornerRadius(10)
        } else {
            Image(uiImage: UIImage(named: selectedSymbol)!)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
                .foregroundColor(.white)
                .background(selectedColor)
                .frame(width: 50, height: 50)
                .cornerRadius(10)
        }
        
        ColorPicker("Select Background Color", selection: $selectedColor)
            .padding()
            .font(.system(size: 20))
        
        HStack {
            Text("Select Symbol")
                .padding()
                .font(.system(size: 20))
            Spacer()
        }
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(symbols, id: \.self) { symbol in
                        Button(action: {
                            selectedSymbol = symbol
                        }) {
                            if symbol != "default" {
                                Image(uiImage: UIImage(named: symbol)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(selectedColor)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedSymbol = symbol
                                    }
                            } else {
                                Rectangle()
                                    .scaledToFit()
                                    .foregroundColor(Color(red:0,green:0,blue:0,opacity: 0))
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(selectedColor)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

