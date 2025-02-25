
import csv
import json
filename = "updated_ramadan_calendar_with_District.csv"
fields = []
rows = []
with open(filename, 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    fields = next(csvreader)
    for row in csvreader:
        rows.append(row)

    print("Total no. of rows: %d" % (csvreader.line_num))
print('Field names are:' + ', '.join(field for field in fields))

dicts = dict()

for row in rows:
    data = {'date': row[1], 'sehar_end': row[3], 'ifter': row[4]}
    district = row[2]
    if(dicts.get(district) == None):
        dicts[district] = [data]
    else:
        dicts[district].append(data)

print('Districts are : ', len(dicts.keys()))

with open('ramadan_calendar2025.json', 'w') as f:
    json.dump(dicts, f, indent= 1)

