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
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 3.0 // Adjusted sample rate to 15 Hz for clarity
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion, error == nil else {
                print("Error reading motion data: \(error!.localizedDescription)")
                completion(false) // Indicate error in motion data collection
                return
            }
            self?.isCollecting = true
            print("Collecting motion data...")
            
            // Create an array of motion data in the expected order
            let motionData: [[Double]] = [[
                motion.userAcceleration.x,
                motion.userAcceleration.y,
                motion.userAcceleration.z,
                motion.rotationRate.x,
                motion.rotationRate.y,
                motion.rotationRate.z
            ]]
            
            self?.sendDataToAPI(motionData: motionData, completion: completion)
        }
    }
    
    func stopUpdates() {
        motionManager?.stopDeviceMotionUpdates()
        isCollecting = false
        print("Stopped collecting motion data.")
    }
    
    private func sendDataToAPI(motionData: [[Double]], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://nittanyai-ro4jz76zva-ue.a.run.app/predict") else {
            print("Invalid API URL.")
            completion(false)
            return
        }
        
        let requestGroup = DispatchGroup()
        var isSuccess = true
        
        for dataChunk in motionData {
            requestGroup.enter()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let payload = ["data": [dataChunk]]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            } catch {
                print("Error: cannot create JSON from payload")
                completion(false)
                return
            }
            
            print("Sending data to API...")
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer {
                    requestGroup.leave()
                }
                
                guard let data = data, error == nil else {
                    print("Error sending data to API: \(error?.localizedDescription ?? "Unknown error")")
                    isSuccess = false
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(jsonResponse)")
                        
                        if let dictionary = jsonResponse as? [String: Any],
                           let predictionNestedArray = dictionary["prediction"] as? [[Any]],
                           let firstPredictionArray = predictionNestedArray.first as? [Double],
                           let predictionValue = firstPredictionArray.first {
                            print("Parsed Prediction: \(predictionValue)")
                            completion(predictionValue >= 0.5675)
                        } else {
                            print("Error: Unexpected data format")
                            isSuccess = false
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                        isSuccess = false
                    }
                } else {
                    print("API request failed with response: \(String(describing: response))")
                    isSuccess = false
                }
            }.resume()
        }
        
        requestGroup.notify(queue: .main) {
            completion(isSuccess)
        }
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
    @State private var feedbackGradient = Gradient(colors: [.gray]) // Default gradient

    var body: some View {
        VStack {
            Text("Workout Session for (bodyPart)").padding()
            Text(sessionActive ? "Session Active" : "Session Inactive")
                .padding()
                .foregroundColor(sessionActive ? .green : .red)

            Button(sessionActive ? "Stop Workout" : "Start Workout") {
                if sessionActive {
                    motionManager.stopUpdates()
                    feedbackGradient = Gradient(colors: [Color.gray])
                } else {
                    motionManager.startUpdates(bodyPart: bodyPart) { goodPrediction in
                        if !goodPrediction {
                            feedbackGradient = Gradient(colors: [Color.pink, Color.red])
                            WKInterfaceDevice.current().play(.failure)
                        } else {
                            feedbackGradient = Gradient(colors: [Color.green, Color.blue])
                        }
                    }
                }
                sessionActive.toggle()
            }
        }
        .background(LinearGradient(gradient: feedbackGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .padding()
        .onAppear {
            feedbackGradient = Gradient(colors: [.gray]) // Neutral starting gradient
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





