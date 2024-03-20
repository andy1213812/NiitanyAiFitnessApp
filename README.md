# NiitanyAiFitnessApp
 
### CoreMotion
##### Our project utilizes the CoreMotion framework to access gyroscope data on iOS devices. For more detailed information on CoreMotion, visit the [CoreMotion Documentation](https://developer.apple.com/documentation/coremotion)
### Gyroscope Data Collection
##### To understand how we collect and use gyroscope data, refer to the [Getting Raw Gyroscope Events guide](https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events). This documentation provides essential insights into accessing and interpreting gyroscope data for motion detection and analysis.
### Accelerometer Data Collection 
##### To understand how we collect and use gyroscope data, refer to the [Getting Raw Accelerometer Events guide](https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events). This documentation provides essential insights into accessing and interpreting gyroscope data for motion detection and analysis.
### Troubleshooting During development
##### you might encounter issues where gyroscope data isn't showing up in Xcode as expected. A useful discussion on troubleshooting this can be found in this [Developer Forum Thread](https://developer.apple.com/forums/thread/685973). It provides insights and potential fixes for common problems related to gyroscope data collection in iOS development.


# Documentation
### Datasets Folders
##### The raw datasets collected from the accelerometer and gyroscope are inside the "Datasets" folder, while the clean datasets with labels are inside the "CleanDatasets" folder.

### Training Model
##### We are using an LSTM model to train our datasets. The code is inside the file [LSTM.py](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/LSTM.py) Additionally, we are also attempting to train our model using CNN. The source code is inside the file [CNN.ipynb](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/CNN.ipynb)

### How to use 
##### Please download xcode on your computer and run the file [AItheleteZoneApp.xcodeproj](https://github.com/andy1213812/NiitanyAiFitnessApp/tree/main/AitheleteZoneApp.xcodeproj), If you do not have an Apple Watch, you can preview it, but there's no guarantee that the CoreMotion API will work. If you have an Apple watch, pair your xcode with the Apple Watch and run it.

### Google Cloud Deploy
##### We made our API file [App.py](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/app.py)
