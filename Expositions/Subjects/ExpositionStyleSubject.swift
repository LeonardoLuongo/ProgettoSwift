import SwiftUI

// This view defines the style of a single element in the list of expositions of user-made sections
struct ExpositionStyleSubject: View {
    @Binding var exposition: Exposition
    var dateFormatter: DateFormatter
    
    init(exposition: Binding<Exposition>) {
        self._exposition = exposition
        self.dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM.dd.yyyy"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if exposition.favorite {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            .padding([.leading, .top])
                    }
                    if exposition.recordingManager.recordName != "" {
                        Text(exposition.recordingManager.recordName)
                            .font(.title2)
                            .foregroundStyle(.black)
                            .padding([.top,.leading])
                    } else {
                        Text(exposition.recordingManager.defaultRecordName)
                            .font(.title2)
                            .padding([.top,.leading])
                    }
                }
                Text(NSLocalizedString("Created on", comment: "") + " \(dateFormatter.string(from: exposition.date))")
                    .padding([.leading,.bottom])
                    .foregroundColor(Color(red: 128/255, green: 128/255, blue: 128/255))
            }
            Spacer()
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(exposition.gradeStyle().background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(exposition.grade)
                    .font(.system(size: 25))
                    .bold()
                    .foregroundStyle(exposition.gradeStyle().textColor)
                if exposition.grade == "10" {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                        .offset(CGSize(width: 18, height: 15))
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                        .offset(CGSize(width: -24, height: -12))
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                        .foregroundStyle(Color(red: 254/255, green: 180/255, blue: 63/255))
                        .offset(CGSize(width: -8, height: -24))
                }
            }
            .padding()
        }
    }
}
