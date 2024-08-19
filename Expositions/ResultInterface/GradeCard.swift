import SwiftUI

struct GradeCard: View{
    var number: Int = 2
    @ObservedObject var exposition: Exposition

    var body: some View {
        GeometryReader { metrics in
            VStack {
                HStack {
                    Spacer()
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("Final grade:")
                                .font(.title)
                                .padding()
                                .foregroundStyle(.black)
                            ZStack {
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(exposition.gradeStyle().background)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(exposition.grade)
                                    .font(.system(size: 70))
                                    .bold()
                                    .foregroundStyle(exposition.gradeStyle().textColor)
                                if exposition.grade == "10" {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                                        .offset(CGSize(width: 45, height: 40))
                                        .font(.system(size: 30))
                                    Image(systemName: "star.fill")
                                        .imageScale(.large)
                                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                                        .offset(CGSize(width: -50, height: -30))
                                        .font(.system(size: 30))
                                    Image(systemName: "star.fill")
                                        .imageScale(.small)
                                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                                        .offset(CGSize(width: -25, height: -50))
                                        .font(.system(size: 30))
                                }
                            }
                            .padding()
                            if let finalEvaluation = exposition.finalEvaluation {
                                Rectangle()
                                    .frame(width: metrics.size.width * 0.7, height: 2)
                                    .cornerRadius(100)
                                    .foregroundStyle(.black)
                                    .padding(.vertical)
                                Text("Final evaluation:")
                                    .font(.title)
                                    .foregroundStyle(.black)
                                    .padding()
                                Text(finalEvaluation)
                                    .foregroundStyle(.black)
                                    .padding([.leading, .trailing])
                            }
                            Spacer()
                        }
                    }
                    .frame(width: metrics.size.width * 0.8, height: metrics.size.height * 0.85)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10, y: 15.0)

                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    GradeCard(number: 5, exposition: Exposition(date: "07-20-2024", grade: "10", secCode: 3))
}
