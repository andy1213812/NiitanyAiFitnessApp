# NiitanyAiFitnessApp
 
### CoreMotion
##### Our project utilizes the CoreMotion framework to access gyroscope data on iOS devices. For more detailed information on CoreMotion, visit the [CoreMotion Documentation](https://developer.apple.com/documentation/coremotion)
### Gyroscope Data Collection
##### To understand how we collect and use gyroscope data, refer to the [Getting Raw Gyroscope Events guide](https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events). This documentation provides essential insights into accessing and interpreting gyroscope data for motion detection and analysis.
### Accelerometer Data Collection 
##### To understand how we collect and use gyroscope data, refer to the [Getting Raw Accelerometer Events guide](https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events). This documentation provides essential insights into accessing and interpreting gyroscope data for motion detection and analysis.
### Troubleshooting During development
##### you might encounter issues where gyroscope data isn't showing up in Xcode as expected. A useful discussion on troubleshooting this can be found in this [Developer Forum Thread](https://developer.apple.com/forums/thread/685973). It provides insights and potential fixes for common problems related to gyroscope data collection in iOS development.


# AIthleteZone: Enhancing Workout Form with AI and Wearable Technology

## Introduction

AIthleteZone is a groundbreaking application that leverages advanced AI technologies, including LSTM (Long Short-Term Memory) networks and CNNs (Convolutional Neural Networks), in combination with the accelerometer and gyroscope of not only the Apple Watch but any other smart watches. This innovative approach allows users to improve their workout forms by providing real-time feedback on their exercise execution, making it an essential tool for beginners and fitness enthusiasts alike.

## Objective

Our project's primary objective is to develop an advanced tool utilizing a sophisticated deep learning neural network model designed specifically to reduce the risk of injury during workouts. Recognizing the particular vulnerability of beginners and the elderly to exercise-related injuries, our solution aims not only to offer step-by-step workout guidance but also to implement preventive measures for these high-risk groups. Through this product, we are committed to facilitating safer fitness routines, promoting long-term physical wellbeing, and ensuring that users from all backgrounds can engage in physical activity with confidence and security.

## Technology and Use of Machine Learning

We have identified that the accelerometers in Apple Watches can effectively capture detailed characteristics and patterns of physical movements. This data is then deconstructed into various attributes to be leveraged during the model training phase. We employ an LSTM (Long Short-Term Memory) network architecture to address the sequential and non-independent nature of our data. Our approach encompasses comprehensive data acquisition about user movement from multiple dimensions. Furthermore, we adopt a convolutional neural network (CNN) framework for training a model capable of providing feedback on a user’s workout through photos or videos. The CNN’s performance is enhanced by preprocessing training images with a pretrained human pose tracking model, which allows for precise classification of a user’s form and movement patterns.

## General Audience

Our application welcomes new gym-goers, regardless of age and gender. We focus on the correctness of form while working out, which both people with little to no experience and people with years of experience can benefit from.

## Data Privacy

Our policy on data management and protection is centered on the principles of transparency, integrity, and confidentiality. Firstly, we will ensure that all user data collected through our deep learning tool is explicitly consented to by users, with a clear understanding of what data is being collected and for what purpose. Health-related data will be encrypted both in transit and at rest, using industry-standard security protocols to prevent unauthorized access. Users will retain full control over their data, with the ability to access, rectify, or delete their information upon request. Regular privacy impact assessments will be conducted to identify and mitigate risks, ensuring continuous improvement in our data protection practices. Our commitment is to uphold the highest standards of data ethics, treating every piece of information with the utmost respect and care, thereby earning and maintaining the trust of our users.

## Datasets and Model Training

#### Datasets Folders
The raw datasets collected from the accelerometer and gyroscope are stored in the "Datasets" folder, while the processed and labeled datasets are in the "CleanDatasets" folder.

#### Training Model
We are using an LSTM model to train our datasets, available in [LSTM.py](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/LSTM.py). Additionally, we are exploring the use of CNN for model training, with the source code available in [CNN.ipynb](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/computer_vision/CNN.ipynb).

# How to Use

Please download Xcode on your computer and open the file [AItheleteZoneApp.xcodeproj](https://github.com/andy1213812/NiitanyAiFitnessApp/tree/main/AitheleteZoneApp.xcodeproj). If you do not have an Apple Watch, you can preview the app, but the full functionality, especially the CoreMotion API, may not be available. For Apple Watch users, pair your device with Xcode and run the project to enjoy the full experience.

## Google Cloud Deployment

We have developed our backend API, [App.py](https://github.com/andy1213812/NiitanyAiFitnessApp/blob/main/app.py), which is deployed on Google Cloud. This setup ensures our app's scalability and accessibility for users everywhere.

## Future Potential

The integration of CNN and video capabilities of iPhones opens up new possibilities for enhancing our application's accuracy in monitoring and improving workout form. By harnessing the power of video analysis, we can offer more detailed feedback and personalized guidance, pushing the boundaries of what's possible in virtual fitness coaching. This development not only represents a significant advancement in our app's functionality but also lays the groundwork for future innovations in the field of AI-powered fitness solutions. Computer Vision model training file is available in [computer_vision](https://github.com/andy1213812/NiitanyAiFitnessApp/tree/main/computer_vision)

## Conclusion

AIthleteZone stands at the forefront of merging AI technology with fitness, offering a unique solution for improving workout safety and effectiveness. By leveraging advanced machine learning models and the precision of wearable and mobile technology, we're making personalized fitness guidance more accessible and impactful. Join us in revolutionizing the way people exercise and achieve their fitness goals, ensuring a safer and more informed fitness journey for everyone.

