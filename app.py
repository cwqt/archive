#!flask/bin/python
from flask import Flask, jsonify, make_response, request, json
from datetime import date
import json
import os
import requests
import glob

app = Flask(__name__)

from flask_httpauth import HTTPBasicAuth
auth = HTTPBasicAuth()

import csv

#at 12:00am
#yesterday_set_tracking
  # update yesterday with tracked values
  # pull all commits from that day

#create_day

#extract data from "Time Sinks" exported csv file
#to be placed into the day before json
def yesterday_set_tracking():
  t = {}
  list_of_files = glob.glob('json/*')
  latest_file = max(list_of_files, key=os.path.getctime)
  #kind of shitty, remove 'json/''
  latest_file = latest_file[5:]
  #remove extension, get filename
  f = os.path.splitext(latest_file)[0]

  csv_file = open("csv/"+ f +".csv")
  csv_reader = csv.reader(csv_file, delimiter=',')
  next(csv_reader, None)  # skip the headers
  for row in csv_reader:
    # in seconds
    starttime = float(row[1].replace(',', ''))
    endtime = float(row[2].replace(',', ''))
    hours = (endtime-starttime)/60/60
    if not row[0] in t:
      t[row[0]] = 0
    t[row[0]] += hours

  for key, value in t.items():
    t[key] = float(format(value, '.2f'))

  print(t)

yesterday_set_tracking()

def yesterday_get_commits():

is_prod = os.environ.get('IS_HEROKU', None)
secrets = ""
if is_prod:
  secrets = {"username":os.environ.get('SECRETS_USERNAME'), "password":os.environ.get('SECRETS_PASSWORD')} 
  print(secrets)
else:
  secrets = json.load(open("secrets.json"))

@auth.get_password
def get_password(username):
  if username == secrets["username"]:
    return secrets["password"]
  return None

@auth.error_handler
def unauthorized():
  return make_response(jsonify({'error': 'Unauthorized access'}), 401)

day = {
  "commits": [
    # { "hash": "md5short", "repo": "https://gitlab.com/cass/g"}
  ],
  "info": {
   "writing": 0,
   "visual": 0,
   "audio": 0
  },
  "image": "",
}

@app.route("/")
def welcome():
  contents = '\033[1m' + 'api.cass.si' + '\033[0m'
  contents += " :: https://gitlab.com/cxss/days"
  print contents
  return contents 

@app.route('/days', methods=['GET'])
def get_all_days():
  x = []
  for filename in os.listdir(os.getcwd()+"/json"):
    f = os.path.splitext(filename)[0]
    x.append(f)

  return json.dumps(x)

@app.route('/days', methods=['POST'])
@auth.login_required
def create_day():
  today = date.today()
  filename = today.strftime("%Y%m%d") + '.json'

  fo = open("json/"+filename, "w")
  filebuffer = [""]
  fo.writelines(filebuffer)
  fo.close()

  with open('json/'+filename, 'w') as outfile:
      json.dump(day, outfile)

  return make_response(jsonify({'success': True}), 200)

@app.route('/days/<int:day_id>', methods=['GET'])
def get_day(day_id):
  f = open("json/"+str(day_id)+".json", "r")
  v = json.load(f)
  f.close()
  return v

@app.route('/days/<int:day_id>', methods=['PUT'])
@auth.login_required
def update_day_value(day_id):
  d = get_day(day_id)
  x = request.get_json(force=True)

  # decide on what we're updating
  if "hash" in x:
    d["commits"].append({"hash": x["hash"], "repo": x["repo"]})
  elif "image" in x:
    d["image"] = x["image"]
  elif "info" in x:
    # change hours spent on x.info
    for key, value in x["info"].items():
      if key in d["info"]:
        d["info"][key] += value
  else:
    return make_response(jsonify({'success': False, 'error': 'No instance exists in info'}), 404)

  # write updated day to file
  f = open("json/"+str(day_id)+".json", "w+")
  f.write(json.dumps(d))
  f.close()
  return make_response(jsonify({'success': True}), 200)

@app.route('/build', methods=['GET'])
@auth.login_required
def build_site():
  # curl -X POST -d {} https://api.netlify.com/build_hooks/5a3127c1a6188f469c8ff73c
  res = requests.post('https://api.netlify.com/build_hooks/5a3127c1a6188f469c8ff73c', data={})
  return make_response(jsonify({'success': False, 'message': res.text}), 200)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'success': False, 'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True)

