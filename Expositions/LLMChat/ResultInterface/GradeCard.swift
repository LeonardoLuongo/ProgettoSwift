import SwiftUI

struct GradeCard: View{
    var number: Int = 2
    var grade: String?
    
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    VStack() {
                        if let grade = self.grade {
                            Text("\(grade)")
                                .foregroundColor(.black)
                                .padding(.all)
                        } else {
                            Text("Non so che scrivere")
                                .foregroundColor(.black)
                                .padding(.all)
                        }
                    }
                    .frame(width: metrics.size.width*0.8, height: metrics.size.height*0.95)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    GradeCard(number: 5, grade: "A")
}
