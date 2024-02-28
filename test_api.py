import requests
url = 'http://127.0.0.1:5000/predict'

test_data = [
    [1,0.128688216,-0.161373019,0.021066831,-0.016317785,-0.000237159,-0.020124912]
]

data = {
    'data': [test_data]
}

response = requests.post(url, json=data)

print(response.json())


# Correct data
# 1, -0.024178833, 0.064703286, 0.009083407, 0.004461169, 0.007453547, -0.00954181
# 1, -0.024390554, 0.102901243, 0.054024782, 0.033564031, 0.007207338, -0.026099622
# 1, -0.12093094, 0.135222659, 0.051266283, 0.06173116, -0.016649606, 0.033036768
# 1, -0.267242193, 0.275167465, -0.000875751, 0.124680459, -0.036981955, 0.062302053
# 1, -0.094177626, 0.468355268, -0.099578097, 0.162796259, -0.035999894, 0.103705406
# 1, -0.177800342, 0.362437487, -0.078933805, 0.178174794, -0.002777647, 0.136405349
# 1, 0.059670396, 0.484102368, 0.022026103, 0.113215923, 0.020619389, 0.048931837
# 1, 0.092290126, 0.442929536, 0.099955782, 0.00755918, -0.044600569, -0.045582414
# 1, 0.053400781, 0.43186003, -0.025567781, 0.014648497, -0.018334396, -0.05627805
# 1, -0.050453581, 0.239617303, 0.031342108, 0.020713806, 0.044285301, -0.02203536
# 1, 0.128633216, 0.20964016, 0.044879753, -0.02885133, 0.010028336, -0.157412052
# 1, -0.028806075, 0.294154376, -0.023309954, -0.086909831, -0.03387586, -0.045826197
# 1, 0.025157424, 0.32429716, -0.020826556, -0.104694605, 0.036320902, -0.006348431
# 1, -0.011192594, 0.331910312, 0.003625524, -0.095090091, -0.000765294, -0.083646119
# 1, 0.026023883, 0.023801263, -0.01611436, -0.050491929, 0.019229636, -0.111421108
# 1, 0.006177741, -0.012102875, 0.003138965, -0.063046992, -0.008911278, -0.176654279




#Incorrect Data
# 1,0.067138433,-0.200377658,0.013082143,-0.038441062,0.025819879,0.006042659
# 1,0.128688216,-0.161373019,0.021066831,-0.016317785,-0.000237159,-0.020124912
# 1,0.050901935,-0.320145905,-0.046479188,0.045164585,-0.028183412,0.03800714
# 1,0.102133699,-0.452656686,-0.009262045,0.072619438,0.036566854,-0.004673183
# 1,0.164352059,-0.556903839,-0.052066233,0.083852291,0.008420814,0.02249217
# 1,0.028107675,-0.560016513,-0.042852759,0.119410157,-0.055180326,0.15355444
# 1,0.123999849,-0.431887776,-0.048649665,0.163267672,-0.0114082,0.14223671
# 1,0.078893229,-0.181817442,0.123892546,0.118094921,0.027160604,0.143340945
# 1,0.004239626,-0.015721561,0.196253568,-0.023925781,-0.04173097,0.043322146
# 1,0.163875893,-0.185028091,-0.099625498,0.10315001,0.133836791,-0.082618475
# 1,-0.148387194,-0.065127991,-0.0277822,0.016792059,-0.04019025,0.013286948
# 1,0.006676285,0.196432322,0.091168419,0.027175725,0.011251144,0.045799792
# 1,0.002491926,0.129172429,-0.009405855,0.097461879,-0.019926675,0.115264177
# 1,0.071663141,0.478864342,0.048588738,0.14349407,0.034986984,0.110078931
# 1,-0.075287022,0.35276407,-0.029198203,0.144223869,-0.028800864,0.197456181


