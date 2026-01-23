//
//  ServiceDetailView.swift
//  AutoMate
//
//  Created by oto rurua on 23.01.26.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceRecord
    let carId: String
    @StateObject private var vehicleManager = VehicleManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var note: String = ""
    @State private var showConfirmAlert = false
    
    var body: some View {
        List {
            Section(header: Text("ინფორმაცია")) {
                LabeledContent("სერვისი", value: service.title)
                LabeledContent("თარიღი", value: service.date.formatted(date: .long, time: .omitted))
                
                HStack {
                    Text("სტატუსი")
                    Spacer()
                    Text(service.isCompleted ? "შესრულებულია" : "დაგეგმილია")
                        .foregroundColor(service.isCompleted ? .green : .orange)
                        .fontWeight(.bold)
                }
            }
            
            if !service.isCompleted {
                Section(header: Text("შესრულებული სამუშაოს აღწერა")) {
                    TextEditor(text: $note)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2))
                        )
                }
                
                Spacer()
                
                Button(action: {
                    showConfirmAlert = true
                }) {
                    Text("სერვისის დასრულება")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 10)
            } else if let savedNotes = service.note, !savedNotes.isEmpty {
                Section(header: Text("ჩანაწერები")) {
                    Text(savedNotes)
                        .font(.body)
                        .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("დეტალები")
        .navigationBarTitleDisplayMode(.inline)
        // Alert-ის ბლოკი, რომელიც ამოხტება ღილაკზე დაჭერისას
        .alert("სერვისის დადასტურება", isPresented: $showConfirmAlert) {
            Button("გაუქმება", role: .cancel) { } // არაფერს აკეთებს, უბრალოდ ხურავს
            Button("დადასტურება") {
                if let serviceId = service.id {
                    vehicleManager.completeService(carId: carId, serviceId: serviceId, note: note)
                    dismiss()
                }
            }
        } message: {
            Text("ნამდვილად გსურთ სერვისის დასრულებულად მონიშვნა? ეს ჩანაწერი გადავა ისტორიაში.")
        }
        .onAppear {
            if let existingNotes = service.note {
                note = existingNotes
            }
        }
    }
}

