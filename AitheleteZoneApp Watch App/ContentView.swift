//
//  ContentView.swift
//  AitheleteZoneApp Watch App
//
//  Created by yuan chen on 2/9/24.
//

import SwiftUI

let gradient1 = LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

// Main ContentView that hosts the navigation
struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .background(
            gradient1
        )
    }
}

struct WelcomeView: View {
    var body: some View {
        Text("AIthlete Zone")
            .font(.largeTitle)
            .foregroundStyle(gradient1)
            .shadow(color: .secondary, radius: 0)
        NavigationLink(destination: HeightSettingView()) {
            Text("Let's Begin!")
        }
        .frame(width: 135, height: 54)
        .background(
            Capsule()
                .fill(Color.blue)
        )
        .foregroundColor(.white)
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
                .padding([.bottom], 5)
            
            HStack {
                Picker("Feet", selection: $feet) {
                    ForEach(0..<8) { feet in
                        Text("\(feet) ft").tag(feet)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(width: 60, height: 85)
                .clipped()
                
                Picker("Inches", selection: $inches) {
                    ForEach(0..<12) { inches in
                        Text("\(inches) in").tag(inches)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(width: 60, height: 85)
                .clipped()
            }
            
            
            NavigationLink(destination: WeightSettingView()) {
                Text("Next")
            }
            .frame(width: 135, height: 54)
            .background(
                Capsule()
                .fill(Color.blue)
            )
            .foregroundColor(.white)
        }
        
    }
}

// Weight Setting View
struct WeightSettingView: View {
    @State private var weight: Int = 150
    
    var body: some View {
        VStack {
            Text("Set Your Weight")
                .font(.headline)
                .padding([.bottom], 5)

            Picker("Weight", selection: $weight) {
                ForEach(50..<301) { weight in
                    Text("\(weight) lbs").tag(weight)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .frame(width: 125, height: 85)
            .clipped()
            
            NavigationLink(destination: BodyPartCategoryView()) {
                Text("Next")
            }
            
            .frame(width: 135, height: 54)
            .background(
                Capsule()
                .fill(Color.blue)
            )
            .foregroundColor(.white)
        }
//        .padding([.bottom], 2)
    }
}

// Body Part Category View
struct BodyPartCategoryView: View {
    let bodyParts = ["Shoulders", "Legs", "Chest", "Back"]
    var body: some View {
        VStack {
            ScrollView {
                Text("Select Body Part")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.bottom], 10)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(bodyParts, id: \.self) { bodyPart in
                        NavigationLink(destination: Text("Details for \(bodyPart)")) {
                            Text(bodyPart)
                        }
                        
                        .frame(height: 54)
                        .background(
                            Capsule()
                                .fill(Color.blue)
                        )
                    }
                    .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}


// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



