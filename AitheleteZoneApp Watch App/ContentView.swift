//
//  ContentView.swift
//  AitheleteZoneApp Watch App
//
//  Created by yuan chen on 2/9/24.
//

import SwiftUI

let gradient1 = LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

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
        VStack {
            Image("AIthleteZoneAppIcon")
                .resizable()
                .frame(width: 80, height: 80)
            Text("AIthlete Zone")
                .font(.title2)
                .foregroundStyle(gradient1)
                .shadow(color: .secondary, radius: 0)
            NavigationButton(destination: HeightSettingView(), text: "Let's Begin!", width: 135, height: 54)
        }
    }
}

struct HeightSettingView: View {
    
    @State private var feet = 5
    @State private var inches = 8
    
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
            
            NavigationButton(destination: WeightSettingView(), text: "Next", width: 135, height: 54)
        }
        
    }
}

struct WeightSettingView: View {
    
    @State private var weight = 150
    
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
            
            NavigationButton(destination: BodyPartCategoryView(), text: "Next", width: 135, height: 54)
        }
    }
}

struct BodyPartCategoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(MockData.bodyParts) { bodyPart in
                            NavigationButton(destination: Text("Details for \(bodyPart.bodyPart)"),
                                             text: bodyPart.bodyPart,
                                             width: 160,
                                             height: 54)
                        }
                    }
                }
                .navigationTitle("Select Body Part")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct NavigationButton<Content: View>: View {
    
    let destination: Content
    let text: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(text)
        }
        .frame(width: width, height: height)
        .background(
            Capsule()
                .fill(Color.blue)
        )
        .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
