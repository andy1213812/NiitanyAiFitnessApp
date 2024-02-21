import re
import xlwt
from xlwt import Workbook



class Data_Processer:


    def __init__(self):
        self.num = 0
        self.data = []

    def process_file(self,file_path):

        wb = Workbook()
        sheet1 = wb.add_sheet('sheet 1')
        row = 1
        count = 0
        #initialize titles
        sheet1.write(0,1,f'Time frame' )
        sheet1.write(0,2,f'rotation_x' )
        sheet1.write(0,3,f'rotation_y' )
        sheet1.write(0,4,f'rotation_z' )
        sheet1.write(0,5,f'acceleration_x' )
        sheet1.write(0,6,f'acceleration_y' )
        sheet1.write(0,7,f'acceleration_z' )
        


        with open(file_path,"r") as training_data:
            data_pattern = "Time: ([\d.-]+) seconds,Rotation Rate x: ([\d.-]+),y: ([\d.-]+),z: ([\d.-]+), Acceleration x: ([\d.-]+),y: ([\d.-]+),z: ([\d.-]+)"

            for line in training_data:

                
                data_match = re.search(data_pattern, line)
                # acceleration_match = re.search(acceleration_pattern, line)

                
                if data_match:
                    count += 1
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
                
                    #self.data.append([rotation_x,rotation_y,rotation_z,acceleration_x,acceleration_y,acceleration_z])
                
                sheet1.write(row,1,f'{time}')
                sheet1.write(row,2,f'{rotation_x}')
                sheet1.write(row,3,f'{rotation_y}')
                sheet1.write(row,4,f'{rotation_z}')
                sheet1.write(row,5,f'{acceleration_x}')
                sheet1.write(row,6,f'{acceleration_y}')
                sheet1.write(row,7,f'{acceleration_z}')

                row += 1

              



              


            print(count)
            
            wb.save('correct form testing data.xls') # custumize out file name
            

    
processer = Data_Processer()
processer.process_file("Correct form training data.txt")