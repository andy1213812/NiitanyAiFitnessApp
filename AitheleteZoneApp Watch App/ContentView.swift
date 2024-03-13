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
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 15.0 // Adjusted sample rate to 15 Hz for clarity
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
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the payload with the motion data correctly formatted
        let payload = ["data": motionData]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("Error: cannot create JSON from payload")
            completion(false)
            return
        }
        
        print("Sending data to API...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error sending data to API: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            print("Received response from API.")
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response JSON: \(jsonResponse)")
                    if let dictionary = jsonResponse as? [String: Any], let prediction = dictionary["prediction"] as? Double {
                        DispatchQueue.main.async {
                            completion(prediction >= 0.5)
                        }
                    } else {
                        print("Error: Unexpected data format")
                        completion(false)
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("API request failed with response: \(String(describing: response))")
                completion(false)
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
    @State private var countdown = 3
    @State private var showCountdown = false
    @State private var progress: CGFloat = 1.0

    var body: some View {
        VStack {
            Text("\(bodyPart) Session").padding().font(.headline)
            
            if showCountdown {
                // Circular progress view
                Circle()
                    .stroke(lineWidth: 8)
                    .opacity(0.1)
                    .foregroundColor(Color.blue)
                    .overlay(
                        Text("\(countdown)")
                            .font(.largeTitle)
                            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                                if countdown > 0 {
                                    countdown -= 1
                                    progress -= 1 / 3
                                }
                            }
                    )
                .animation(.easeInOut(duration: 1), value: progress)
                .frame(width: 80, height: 80)
            }
            
            Button(action: {
                if sessionActive {
                    motionManager.stopUpdates()
                    sessionActive = false
                    countdown = 3
                    progress = 1.0
                    showCountdown = false
                } else {
                    withAnimation {
                        showCountdown = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        motionManager.startUpdates(bodyPart: bodyPart) { goodPrediction in
                            withAnimation {
                                showCountdown = false
                            }
                            if goodPrediction {
                                // No haptic feedback if the prediction is good
                            } else {
                                WKInterfaceDevice.current().play(.failure)
                            }
                            sessionActive = true
                        }
                    }
                }
            }) {
                Text(sessionActive ? "Stop Workout" : "Start Workout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            countdown = 3
            progress = 1.0
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





