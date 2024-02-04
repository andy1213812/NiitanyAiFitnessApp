import SwiftUI
// Import SwiftUI
import CoreMotion
// Using CoreMotion API in Collecting datasets from the user

struct ContentView: View {
    @State private var isCollectingData = false
    let motionManager = CMMotionManager()
    var body: some View {
        VStack {
            Button(isCollectingData ? "Stop" : "Start") {
                if isCollectingData {
                    stopCollectingData()
                } else {
                    startCollectingData()
                }
                isCollectingData.toggle()
            }
        }
    }
    
    func startCollectingData() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0  // We can change the Hz Rate in the project, depends on us.
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                guard let accelerometerData = data else { return }
                let acceleration = accelerometerData.acceleration
                let timestamp = accelerometerData.timestamp
                // We are saving the acceleration data and timestamp to your data store
                print("Time: \(timestamp) - Acceleration x: \(acceleration.x) y: \(acceleration.y) z: \(acceleration.z)")
            }
        }
    }

    func stopCollectingData() {
        motionManager.stopAccelerometerUpdates()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
