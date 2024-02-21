#import pandas as pd
import numpy as np
import re
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense



# LLLLLLLLLLLLLLLLLet's start to build a tool that can process our dataaaaaaaaaaaaaaa


class Data_Processer:


    def __init__(self):
        self.num = 0
        self.data = []

    def process_file(self,file_path):
        with open(file_path,"r") as training_data:
            data_pattern = "Time: ([\d.-]+) seconds,Rotation Rate x: ([\d.-]+),y: ([\d.-]+),z: ([\d.-]+), Acceleration x: ([\d.-]+),y: ([\d.-]+),z: ([\d.-]+)"

            for line in training_data:

                
                data_match = re.search(data_pattern, line)
                # acceleration_match = re.search(acceleration_pattern, line)

                
                if data_match:
                    time = data_match.group(1)
                    rotation_x = data_match.group(2)
                    rotation_y = data_match.group(3)
                    rotation_z = data_match.group(4)
                    acceleration_x = data_match.group(5)
                    acceleration_y = data_match.group(6)
                    acceleration_z = data_match.group(7)
                    #print(f"Result Rotation: Time: {time}, x: {x}, y: {y}, z: {z}\n\n")

                    print(f"time: {time}\nrotation: {rotation_x},{rotation_y},{rotation_z}\naccerleration: {acceleration_x},{acceleration_y},{acceleration_z}\n\n")

                # if acceleration_match:
                #     time = acceleration_match.group(1)
                #     x = acceleration_match.group(2)
                #     y = acceleration_match.group(3)
                #     z = acceleration_match.group(4)
                    #print(f"Result Acceleration: Time: {time}, x: {x}, y: {y}, z: {z}\n\n")
                
                    self.data.append([rotation_x,rotation_y,rotation_z,acceleration_x,acceleration_y,acceleration_z])
                




                self.num += 1
                if self.num == 50:
                    break

            

        return self.data








# Now, let's build a tool that can train our model

class Model_training:

    def __init__(self,data,labels_list):
        self.data = data
        self.labels_list = labels_list



    def training_model(self):
        data = self.data.reshape((self.data.shape[0], 1, self.data.shape[1]))

        #print(data)

        # Define LSTM model
        model = Sequential(
            [
                LSTM(64, input_shape=(1, 6)),  # 64 LSTM units
                Dense(1, activation="sigmoid"),  # Output layer with sigmoid activation
            ]
        )

        # Compile the model
        model.compile(optimizer="adam", loss="binary_crossentropy", metrics=["accuracy"])

        # Train the model
        model.fit(data, self.labels_list, epochs=10, batch_size=32)







# We still need to build a class to testfiy out model, but we will do that later

class Model_vaildation:
    pass













# Now, we had all the tool that we need, let's training the model

process_tool = Data_Processer()
correct_training_data = process_tool.process_file("/Users/jackliu/Desktop/2024 Nittany AI Chanllege /Correct form training data.txt")
# incorrect_training_data = process_tool.process_file("/Users/jackliu/Desktop/2024 Nittany AI Chanllege /Training data Squat Incorrect Form.txt")

print(correct_training_data)
print("\n\n\n\n")
# print(incorrect_training_data)





# lets complete our training data
#training_data = correct_training_data + incorrect_training_data # total we have 2D list with 100 sequence where each sequence with 3 data points for acceleration x,y,z
array_correct = np.array(correct_training_data)
# array_incorrect = np.array(incorrect_training_data)

# Element-wise addition
#training_array = array_correct + array_incorrect





#Now lets create our label list

# lst_1 = []
# lst_2 = []

# for i in range(25):
#     lst_1.append(1)

# for i in range(25):
#     lst_2.append(0)

# label_list = lst_1 + lst_2
# print(label_list)


# trainer = Model_training(array_correct,label_list)
# trainer.training_model()






# IDK what to do now Lol. 