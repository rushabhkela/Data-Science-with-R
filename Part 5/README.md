```py
import json
import csv
import time
from jugaad_data.nse import NSELive
from datetime import datetime

 
def normalize_json(data: dict) -> dict:
 new_data = dict()
 for key, value in data.items():
 if not isinstance(value, dict):
 new_data[key] = value
 else:
 for k, v in value.items():
 new_data[key + "_" + k] = v

 return new_data


def generate_csv_data(data: dict) -> str:
 csv_columns = data.keys()
 # csv_data = ",".join(csv_columns) + "\n"
 csv_data = ""
 new_row = list()
 for col in csv_columns:
 new_row.append(str(data[col]))
 csv_data += ",".join(new_row) + "\n"

 return csv_data


def write_to_file(data: str, filepath: str) -> bool:

 try:
 with open(filepath, "a+") as f:
 f.write(data)
 except:
 raise Exception(f"Saving data to {filepath} encountered an
error")


def main():
 n = NSELive()
 q = n.stock_quote("HINDUNILVR")
 data = q['priceInfo']
 now = datetime.now()
 now = now.strftime("%d/%m/%Y %H:%M:%S")
 data['timestamp'] = now
 new_data = normalize_json(data=data)
 print("New dict:", new_data)
 csv_data = generate_csv_data(data=new_data)
 write_to_file(data=csv_data, filepath="stockdata.csv")


if __name__ == '__main__':
 while True:
 main()
 time.sleep(60)
```