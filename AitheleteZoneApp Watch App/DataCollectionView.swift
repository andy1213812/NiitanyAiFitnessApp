import SwiftUI
// Import SwiftUI
import CoreMotion
// Using CoreMotion API in Collecting datasets from the user

struct DataCollectionView: View {
    @State private var isCollectingData = false
    @State private var showAlert = false // State to control alert visibility
    let motionManager = CMMotionManager()
    @State private var startTime: TimeInterval? // Record the start time

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Data Collector 😚")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(isCollectingData ? .green : .blue)
            
            Button(action: {
                // Toggle data collection state
                if isCollectingData {
                    stopCollectingData()
                } else {
                    startCollectingData()
                }
                isCollectingData.toggle()
            }) {
                Text(isCollectingData ? "Stop Collecting" : "Start Collecting")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .background(isCollectingData ? Color.red : Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Unavailable"), message: Text("Motion data not available."), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    func startCollectingData() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // Update at 60 Hz
            motionManager.showsDeviceMovementDisplay = true
            startTime = Date().timeIntervalSince1970 // Record the current time as start time
            
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.current!) { (data, error) in
                guard let validData = data, let start = self.startTime else { return }
                let currentTime = Date().timeIntervalSince1970
                let elapsedTime = currentTime - start // Calculate elapsed time since start
                
                let rotation = validData.rotationRate
                let userAcceleration = validData.userAcceleration
                DispatchQueue.main.async {
                    // Here, you might want to update some UI elements with the data
                    print("Time: \(elapsedTime) seconds - Rotation Rate x: \(rotation.x) y: \(rotation.y) z: \(rotation.z)")
                    print("Time: \(elapsedTime) seconds - Acceleration x: \(userAcceleration.x) y: \(userAcceleration.y) z: \(userAcceleration.z)")
                }
            }
        } else {
            DispatchQueue.main.async {
                showAlert = true // Show alert if device motion is not available
            }
        }
    }

    func stopCollectingData() {
        motionManager.stopDeviceMotionUpdates()
        startTime = nil // Reset start time
    }
}

struct DataCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DataCollectionView()
    }
}
