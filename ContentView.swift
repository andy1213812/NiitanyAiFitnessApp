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
    if motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable {
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0 // Update at 60 Hz for accelerometer
        motionManager.gyroUpdateInterval = 1.0 / 60.0 // Update at 60 Hz for gyroscope
        
        // Start accelerometer updates
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let accelerometerData = data else { return }
            let acceleration = accelerometerData.acceleration
            let accTimestamp = accelerometerData.timestamp
            // Saving the acceleration data and timestamp to your data store
            print("Acc Time: \(accTimestamp) - Acceleration x: \(acceleration.x) y: \(acceleration.y) z: \(acceleration.z)")
        }
        
        // Start gyroscope updates
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (gyroData, error) in
            guard let gyroData = gyroData else { return }
            let rotationRate = gyroData.rotationRate
            let gyroTimestamp = gyroData.timestamp
            // Saving the gyroscope data and timestamp to your data store
            print("Gyro Time: \(gyroTimestamp) - Rotation Rate x: \(rotationRate.x) y: \(rotationRate.y) z: \(rotationRate.z)")
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
