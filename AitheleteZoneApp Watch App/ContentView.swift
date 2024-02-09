//
//  ContentView.swift
//  AitheleteZoneApp Watch App
//
//  Created by yuan chen on 2/9/24.
//

import SwiftUI

// Main ContentView that hosts the navigation
struct ContentView: View {
    var body: some View {
        NavigationStack {
            HeightSettingView()
        }
    }
}

// Height Setting View
struct HeightSettingView: View {
    @State private var feet: Int = 5
    @State private var inches: Int = 8
    
    var body: some View {
        VStack {
            Text("Set Your Height")
                .font(.headline)
            
            HStack {
                Picker("Feet", selection: $feet) {
                    ForEach(0..<8) { feet in
                        Text("\(feet) ft").tag(feet)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50)
                .clipped()
                
                Picker("Inches", selection: $inches) {
                    ForEach(0..<12) { inches in
                        Text("\(inches) in").tag(inches)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50)
                .clipped()
            }
            
            NavigationLink(destination: WeightSettingView()) {
                Text("Next")
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

// Weight Setting View
struct WeightSettingView: View {
    @State private var weight: Int = 150
    
    var body: some View {
        VStack {

            Picker("Weight", selection: $weight) {
                ForEach(50..<301) { weight in
                    Text("\(weight) lbs").tag(weight)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .clipped()
            
            NavigationLink(destination: BodyPartCategoryView()) {
                Text("Next")
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

// Body Part Category View
struct BodyPartCategoryView: View {
    // Define an array for body parts
    let bodyParts = ["Shoulder", "Leg", "Chest", "Back"]
    // Define a gradient background
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

    var body: some View {
        ZStack {
            // Apply gradient background to the entire view
            gradient.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Select Body Part")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .padding(.top, 8) // Add top padding to create space from the top edge and back button
                    .padding(.leading, 8) // Add leading padding to create space from the leading edge

                // Loop through the body parts array
                ForEach(bodyParts, id: \.self) { bodyPart in
                    NavigationLink(destination: Text("Details for \(bodyPart)")) {
                        Text(bodyPart)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
    }
} 






// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



