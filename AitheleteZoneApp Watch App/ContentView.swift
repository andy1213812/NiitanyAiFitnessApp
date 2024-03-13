//
//  ContentView.swift
//  AitheleteZoneApp Watch App
//
//  Created by yuan chen on 2/9/24.
//

import SwiftUI
import Combine
import CoreMotion
import WatchKit

// Gradient background setup
let gradient1 = LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

// Main ContentView structure
struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .background(gradient1)
    }
}

// Welcome view structure
struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("AIthleteZoneAppIcon").resizable().frame(width: 80, height: 80)
            Text("AIthlete Zone").font(.title2).foregroundStyle(gradient1).shadow(color: .secondary, radius: 0)
            NavigationButton(destination: HeightSettingView(), text: "Let's Begin!", width: 135, height: 54)
        }
    }
}

// Height setting view structure
struct HeightSettingView: View {
    @State private var feet = 5
    @State private var inches = 8
    var body: some View {
        VStack {
            Text("Set Your Height").font(.headline).padding([.bottom], 5)
            HStack {
                Picker("Feet", selection: $feet) { ForEach(0..<8) { Text("\($0) ft").tag($0) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
                Picker("Inches", selection: $inches) { ForEach(0..<12) { Text("\($0) in").tag($0) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
            }
            NavigationButton(destination: WeightSettingView(), text: "Next", width: 135, height: 54)
        }
    }
}

// Weight setting view structure
struct WeightSettingView: View {
    @State private var weight = 150
    var body: some View {
        VStack {
            Text("Set Your Weight").font(.headline).padding([.bottom], 5)
            Picker("Weight", selection: $weight) { ForEach(50..<301) { Text("\($0) lbs").tag($0) } }.labelsHidden().pickerStyle(.wheel).frame(width: 125, height: 85).clipped()
            NavigationButton(destination: BodyPartCategoryView(), text: "Next", width: 135, height: 54)
        }
    }
}

// Motion data manager for handling CoreMotion updates and API communication
class MotionDataManager: ObservableObject {
    private var motionManager: CMMotionManager?
    @Published var isCollecting = false
    
    init() {
        motionManager = CMMotionManager()
        if motionManager?.isDeviceMotionAvailable ?? false {
            print("Device Motion is available.")
        } else {
            print("Device Motion is not available.")
        }
    }

    func startUpdates(bodyPart: String, completion: @escaping (Bool) -> Void) {
        guard let motionManager = motionManager, motionManager.isDeviceMotionAvailable else {
            print("Device Motion is not available.")
            completion(false) // Indicate failure to start updates
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 15.0 // Sample rate of 60 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion, error == nil else {
                print("Error reading motion data: \(error!.localizedDescription)")
                completion(false) // Indicate error in motion data collection
                return
            }
            self?.isCollecting = true
            print("Collecting motion data...")
            
            let data: [String: Any] = [
                "accelerationX": motion.userAcceleration.x + motion.gravity.x,
                "accelerationY": motion.userAcceleration.y + motion.gravity.y,
                "accelerationZ": motion.userAcceleration.z + motion.gravity.z,
                "rotationRateX": motion.rotationRate.x,
                "rotationRateY": motion.rotationRate.y,
                "rotationRateZ": motion.rotationRate.z
            ]
            
            self?.sendDataToAPI(data: data, completion: completion)
        }
    }

    func stopUpdates() {
        motionManager?.stopDeviceMotionUpdates()
        isCollecting = false
        print("Stopped collecting motion data.")
    }

    private func sendDataToAPI(data: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://nittanyai-ro4jz76zva-ue.a.run.app/predict") else {
            print("Invalid API URL.")
            completion(false) // Indicate error in API URL
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            print("Error: cannot create JSON from data")
            completion(false)
            return
        }
        
        print("Sending data to API...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error sending data to API: \(error?.localizedDescription ?? "Unknown error")")
                completion(false) // Indicate API communication error
                return
            }
            
            print("Received response from API.")
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let prediction = jsonResponse["prediction"] as? [[Double]] {
                        let predictionValue = prediction.first?.first ?? 0.0
                        print("Prediction value: \(predictionValue)")
                        DispatchQueue.main.async {
                            completion(predictionValue >= 0.5)
                        }
                    } else {
                        print("Error parsing JSON response")
                        completion(false) // Indicate JSON parsing error
                    }
                } catch {
                    print("Error parsing JSON response")
                    completion(false) // Indicate JSON parsing error
                }
            } else {
                print("API request failed with response: \(String(describing: response))")
                completion(false) // Indicate API request failure
            }
        }.resume()
    }
}

// View for selecting the body part to monitor
struct BodyPartCategoryView: View {
    @ObservedObject var motionManager = MotionDataManager()
    // Placeholder for actual body parts data
    let bodyParts = ["Shoulder", "Leg","Chest","Back"]
    
    var body: some View {
        NavigationStack {
            List(bodyParts, id: \.self) { bodyPart in
                NavigationLink(destination: WorkoutSessionView(bodyPart: bodyPart, motionManager: motionManager)) {
                    Text(bodyPart)
                }
            }
        }
    }
}

// View for the workout session
struct WorkoutSessionView: View {
    var bodyPart: String
    @ObservedObject var motionManager: MotionDataManager
    @State private var sessionActive = false
    @State private var backgroundColor = Color.clear
    @State private var feedbackText = "Waiting to start..."
    
    var body: some View {
        VStack {
            Text("Workout Session for \(bodyPart)").padding()
            Text(feedbackText)
                .padding()
                .foregroundColor(sessionActive ? .green : .red)
            
            Button(sessionActive ? "Stop Workout" : "Start Workout") {
                if sessionActive {
                    motionManager.stopUpdates()
                    feedbackText = "Session stopped."
                } else {
                    feedbackText = "Starting session..."
                    motionManager.startUpdates(bodyPart: bodyPart) { goodPrediction in
                        if !goodPrediction {
                            backgroundColor = Color.red
                            feedbackText = "Incorrect form!"
                            WKInterfaceDevice.current().play(.failure)
                        } else {
                            backgroundColor = Color.green
                            feedbackText = "Good form!"
                        }
                    }
                }
                sessionActive.toggle()
            }
        }
        .background(backgroundColor)
        .onAppear {
            backgroundColor = .clear
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
        .background(Capsule().fill(Color.blue))
        .foregroundColor(.white)
    }
}

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





