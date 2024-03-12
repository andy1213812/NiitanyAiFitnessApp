//
//  ContentView.swift
//  AitheleteZoneApp Watch App
//
//  Created by yuan chen on 2/9/24.
//

import SwiftUI
import CoreMotion
import Combine

let gradient1 = LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .background(gradient1)
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("AIthleteZoneAppIcon").resizable().frame(width: 80, height: 80)
            Text("AIthlete Zone").font(.title2).foregroundStyle(gradient1).shadow(color: .secondary, radius: 0)
            NavigationButton(destination: HeightSettingView(), text: "Let's Begin!", width: 135, height: 54)
        }
    }
}

struct HeightSettingView: View {
    @State private var feet = 5
    @State private var inches = 8
    var body: some View {
        VStack {
            Text("Set Your Height").font(.headline).padding([.bottom], 5)
            HStack {
                Picker("Feet", selection: $feet) { ForEach(0..<8) { feet in Text("\(feet) ft").tag(feet) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
                Picker("Inches", selection: $inches) { ForEach(0..<12) { inches in Text("\(inches) in").tag(inches) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
            }
            NavigationButton(destination: WeightSettingView(), text: "Next", width: 135, height: 54)
        }
    }
}

struct WeightSettingView: View {
    @State private var weight = 150
    var body: some View {
        VStack {
            Text("Set Your Weight").font(.headline).padding([.bottom], 5)
            Picker("Weight", selection: $weight) { ForEach(50..<301) { weight in Text("\(weight) lbs").tag(weight) } }.labelsHidden().pickerStyle(.wheel).frame(width: 125, height: 85).clipped()
            NavigationButton(destination: BodyPartCategoryView(), text: "Next", width: 135, height: 54)
        }
    }
}

class MotionDataManager: ObservableObject {
    private var motionManager: CMMotionManager?
    private var timer: Timer?
    @Published var isCollecting = false
    func startUpdates(bodyPart: String, completion: @escaping (Double) -> Void) {
        isCollecting = true
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let data = self.motionManager?.accelerometerData else { return }
            self.sendDataToAPI(bodyPart: bodyPart, data: data, completion: completion)
        }
    }
    func stopUpdates() {
        isCollecting = false
        motionManager?.stopAccelerometerUpdates()
        timer?.invalidate()
        timer = nil
        motionManager = nil
    }
    private func sendDataToAPI(bodyPart: String, data: CMAccelerometerData, completion: @escaping (Double) -> Void) {
        let url = URL(string: "https://nittanyai-ro4jz76zva-ue.a.run.app/predict")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["bodyPart": bodyPart, "accelerationX": data.acceleration.x, "accelerationY": data.acceleration.y, "accelerationZ": data.acceleration.z]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error: cannot create JSON from body")
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error sending data to API: \(String(describing: error))")
                return
            }
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let probability = responseJSON["probability"] as? Double {
                DispatchQueue.main.async {
                    completion(probability)
                }
            }
        }.resume()
    }
}

struct BodyPartCategoryView: View {
    @ObservedObject var motionManager = MotionDataManager()
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(MockData.bodyParts) { bodyPart in
                            NavigationLink(destination: WorkoutSessionView(bodyPart: bodyPart.bodyPart, motionManager: motionManager)) {
                                Text(bodyPart.bodyPart).frame(width: 160, height: 54).background(Capsule().fill(Color.blue)).foregroundColor(.white)
                            }
                        }
                    }
                }.navigationTitle("Select Body Part").navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct WorkoutSessionView: View {
    var bodyPart: String
    @ObservedObject var motionManager: MotionDataManager
    @State private var backgroundColor = LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)

    var body: some View {
        VStack {
            Text("Workout Session for \(bodyPart)").padding()
            Spacer()
            Button(action: {
                motionManager.stopUpdates()
            }) {
                Image(systemName: "stop.circle.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).background(Color.white).clipShape(Circle()).foregroundColor(.red)
            }.padding().background(backgroundColor).onAppear {
                motionManager.startUpdates(bodyPart: bodyPart) { probability in
                    if probability < 0.5 {
                        let redGradient = LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        backgroundColor = redGradient
                        WKInterfaceDevice.current().play(.failure)
                    }
                }
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
        }.frame(width: width, height: height).background(Capsule().fill(Color.blue)).foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

