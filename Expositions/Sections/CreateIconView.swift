import SwiftUI

// this view is used to create new custom icons
struct CreateIconView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedSymbol: String
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Text("Create icon")
                    .font(.system(size: 30))
                    .bold()
                    .padding([.top,.leading])
                    .bold()
                Spacer()
            }
            IconView(selectedSymbol: $selectedSymbol, selectedColor: $selectedColor)
        }
            
        Spacer()
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    CreateIconView(selectedSymbol: .constant("LETTERATURA ITALIANA"), selectedColor: .constant(Color(red: 0.6784313725490196, green: 0.6784313725490196, blue: 0.6784313725490196)))
}
