import csv

def merge_lat_long(calendar_file, latlong_file, output_file):
    """
    Merges latitude and longitude from latlong_file into calendar_file
    and writes to output_file.
    """
    
    # 1. Read lat/long data into a dictionary
    lat_long_map = {}
    try:
        with open(latlong_file, mode='r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            # Normalize column names just in case (strip whitespace)
            reader.fieldnames = [name.strip() for name in reader.fieldnames]
            
            for row in reader:
                district = row['District'].strip()
                lat = row['Latitude'].strip()
                long = row['Longitude'].strip()
                lat_long_map[district] = (lat, long)
    except FileNotFoundError:
        print(f"Error: File '{latlong_file}' not found.")
        return
    except KeyError as e:
        print(f"Error: Missing column in '{latlong_file}': {e}")
        return

    # 2. Read calendar data and merge
    try:
        with open(calendar_file, mode='r', encoding='utf-8') as infile, \
             open(output_file, mode='w', encoding='utf-8', newline='') as outfile:
            
            reader = csv.DictReader(infile)
            # Normalize column names
            original_fieldnames = [name.strip() for name in reader.fieldnames]
            
            # Prepare new fieldnames
            new_fieldnames = original_fieldnames + ['Latitude', 'Longitude']
            
            writer = csv.DictWriter(outfile, fieldnames=new_fieldnames)
            writer.writeheader()
            
            for row in reader:
                # Clean up the row keys and values if necessary
                clean_row = {k.strip(): v.strip() for k, v in row.items()}
                
                district = clean_row.get('District')
                
                if district in lat_long_map:
                    lat, long = lat_long_map[district]
                    clean_row['Latitude'] = lat
                    clean_row['Longitude'] = long
                else:
                    # Handle missing district if needed, for now leave empty or print warning
                    print(f"Warning: Lat/Long not found for district '{district}'")
                    clean_row['Latitude'] = ''
                    clean_row['Longitude'] = ''
                
                writer.writerow(clean_row)
                
        print(f"Successfully created '{output_file}'")

    except FileNotFoundError:
        print(f"Error: File '{calendar_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    calendar_csv = 'updated_ramadan_calendar_with_District.csv'
    latlong_csv = 'latlong_of_districts.csv'
    output_csv = 'updated_ramadan_calendar_with_latlong.csv'
    
    merge_lat_long(calendar_csv, latlong_csv, output_csv)
