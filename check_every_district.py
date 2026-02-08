import json
import os

with open('ramadan_calendar_2026.json', 'r') as f:
    data = json.load(f)

with open("List_of_district.json", "r") as f:
    districts = json.load(f)

count = 0
for district in districts:
    if district not in data:
        count += 1
print(count)