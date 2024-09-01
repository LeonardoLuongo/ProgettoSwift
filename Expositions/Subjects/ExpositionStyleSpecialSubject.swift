import SwiftUI

// This view defines the style of a single element in the list of expositions of special sections (Trash, Favorites, All expositions)
struct ExpositionStyleSpecialSubject: View {
    @Binding var exposition: Exposition
    @Binding var expositions: [Int:[Exposition]]
    @Binding var sections: [Section]
    var dateFormatter: DateFormatter
    
    private var sourceSection: Section?

    private var colorArray: [Color] = {
        var array: [Color] = []
        for _ in 0..<15 {
            array.append(Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)))
        }
        return array
    }()
    
    private var strokeColor: Color?
    private var shapeColor: Color?

    init(exposition: Binding<Exposition>, expositions: Binding<[Int:[Exposition]]>, sections: Binding<[Section]>) {
        self._exposition = exposition
        self._expositions = expositions
        self._sections = sections
        self.dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM.dd.yyyy"
        if let section = self.sections.first(where: {$0.secCode == self.exposition.secCode}) {
            self.sourceSection = section
        } else {
            self.sourceSection = self.sections[0]
        }
        (shapeColor, strokeColor) = sectionColor()
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
                HStack(alignment: .top) {
                    Text(sourceSection!.name)
                        .padding(5)
                        .font(.system(size: 8))
                        .foregroundStyle(.black)
                        .frame(width: .infinity, height: 20)
                        .background(shapeColor!)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(strokeColor!, lineWidth: 1.5))
                    .padding(.leading)
                    if !exposition.trash {
                        Text(NSLocalizedString("Created on", comment: "") + " \(dateFormatter.string(from: exposition.date))")
                            .padding(.bottom)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 128/255, green: 128/255, blue: 128/255))
                    } else {
                        Text(NSLocalizedString("Deleted in", comment: "") + " " + timeRemaining(startDate: exposition.trashDate!) + " " + NSLocalizedString("days", comment: ""))
                            .padding(.bottom)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                    }
                }
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
                if exposition.grade == "10" { // stars are added if the grade is 10
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
    
    // This function is used to create the label an exposition (that shows the section of the exposition)
    func sectionColor() -> (shapeColor: Color, strokeColor: Color) {
        let strokeColor: Color
        if let icon = sourceSection?.icon {
            if let color = icon.color {
                strokeColor = color
            } else {
                strokeColor = colorArray[Int.random(in: 0...15)]
            }
        } else {
            strokeColor = colorArray[Int.random(in: 0...15)]
        }
        let shapeColor = strokeColor.opacity(0.7)
        return (shapeColor: shapeColor, strokeColor: strokeColor)
    }
    
    // This function is used to calculate the time remaining for an exposition in the trash to be permantly deleted
    func timeRemaining(startDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if let newDate = Calendar.current.date(byAdding: .day, value: 30, to: startDate) {
            let components = calendar.dateComponents([.day], from: now, to: newDate)
            return "\(components.day ?? 0)"
        }
        return ""
    }
}
