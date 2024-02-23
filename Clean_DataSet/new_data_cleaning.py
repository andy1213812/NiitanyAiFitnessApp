import pandas as pd
import re

data = []

rep_number = 0  

with open('Datasets/Squat_Correct_2.rtf') as file:
    for line in file:
        if 'Rep,' in line:
            rep_number = int(line.split(',')[1].strip())
        else:
            match = re.search(r'Time: ([\d.]+) seconds, Rotation Rate x: ([\-\d.]+), y: ([\-\d.]+), z: ([\-\d.]+), Acceleration x: ([\-\d.]+), y: ([\-\d.]+), z: ([\-\d.]+)', line)
            if match:  
                time, rot_x, rot_y, rot_z, acc_x, acc_y, acc_z = match.groups()
                data.append([rep_number, float(time), float(rot_x), float(rot_y), float(rot_z), float(acc_x), float(acc_y), float(acc_z)])

columns = ['Rep', 'Time (s)', 'Rotation Rate x', 'Rotation Rate y', 'Rotation Rate z', 'Acceleration x', 'Acceleration y', 'Acceleration z']
df = pd.DataFrame(data, columns=columns)

excel_file_path = 'extracted_data_with_default_reps.xlsx'
df.to_excel(excel_file_path, index=False)

excel_file_path








