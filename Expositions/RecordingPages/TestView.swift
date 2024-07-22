//
//  TestView.swift
//  RecordingPages
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct TestView: View {
    @StateObject private var recordingManager1 = RecordingManager()
    @StateObject private var recordingManager2 = RecordingManager()
    @StateObject private var recordingManager3 = RecordingManager()
    
    @Binding var expositions: [Int:[Exposition]]
    
    
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: RecordPage(recordingManager: recordingManager1, expositions: $expositions)) {
                    if recordingManager1.recordName != "" {
                        Text(recordingManager1.recordName)
                    } else {
                        Text(recordingManager1.defaultRecordName)
                    }
                }
                
                NavigationLink(destination: RecordPage(recordingManager: recordingManager2, expositions: $expositions)) {
                    if recordingManager2.recordName != "" {
                        Text(recordingManager2.recordName)
                    } else {
                        Text(recordingManager2.defaultRecordName)
                    }
                }
                
                NavigationLink(destination: RecordPage(recordingManager: recordingManager3, expositions: $expositions)) {
                    if recordingManager3.recordName != "" {
                        Text(recordingManager3.recordName)
                    } else {
                        Text(recordingManager3.defaultRecordName)
                    }
                }
            }
            .navigationBarTitle("Record Pages")
        }
    }

}

#Preview {
    TestView(expositions: .constant([3:[Exposition(date: "07-20-2024", grade: "10", secCode: 3)]]))
}
