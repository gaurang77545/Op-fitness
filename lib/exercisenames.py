from fileinput import filename
from collections import Counter
filename=open("exercises.txt","r")

with filename as f:
    lines = f.read().split('\n')
# print(lines)
exercisename = lines[0::3]
exercisecategory=lines[1::3]
# counter=1
# for i in exercisecategory:
#     if(i=='Arms '):
#         print(counter)
#     counter+=3
# print(Counter(exercisecategory).keys()) # equals to list(set(words))
# print(Counter(exercisecategory).values()) # counts the elements' frequency
print(exercisecategory)
# print(exercisename)