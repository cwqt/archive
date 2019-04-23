#!flask/bin/python
from flask import Flask, jsonify, make_response, request, json
from datetime import datetime, timedelta
from flask_httpauth import HTTPBasicAuth
import json
import os
import requests
import glob
import csv
import gitlab

app = Flask(__name__)
auth = HTTPBasicAuth()

#heroku/local checking
is_prod = os.environ.get('IS_HEROKU', None)
secrets = ""
if is_prod:
  secrets = {"username":os.environ.get('SECRETS_USERNAME'), "password":os.environ.get('SECRETS_PASSWORD'), "token":os.environ.get('SECRETS_TOKEN')} 
  print(secrets)
else:
  secrets = json.load(open("secrets.json"))

#at 12:00am
#yesterday_set_tracking
  # update yesterday with tracked values
  # pull all commits from that day

#create_day

#get yesteday json
def yesterday_get():
  list_of_files = glob.glob('json/*')
  latest_file = max(list_of_files, key=os.path.getctime)
  #kind of shitty, remove 'json/''
  latest_file = latest_file[5:]
  #remove extension, get filename
  f = os.path.splitext(latest_file)[0]
  return f

#extract data from "Time Sinks" exported csv file
#to be placed into the day before json
def yesterday_get_tracking():
  t = {}
  f = yesterday_get()

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

  return t

#get all commits from yestersdays date via gitlab api
def yesterday_get_commits():
  t = []
  yesterday_date = datetime.strftime(datetime.now() - timedelta(1), '%Y-%m-%d')
  # $ curl --header "PRIVATE-TOKEN: <token>" -X GET 'https://gitlab.com/api/v4/events?action_type=pushed&after=2019-04-21'
  #get all commits
  headers = {'PRIVATE-TOKEN': secrets["token"]}
  res = requests.get('https://gitlab.com/api/v4/events?action_type=pushed&after='+yesterday_date, headers=headers)
  commits = res.json()
  for commit in commits:
    x = {}
    commit_hash = commit["push_data"]["commit_to"][:8]

    #get commit repo
    #$ curl --header "PRIVATE-TOKEN: <token>" -X GET 'https://gitlab.com/api/v4/projects/11960084'
    project_id = str(commit["project_id"])
    res = requests.get('https://gitlab.com/api/v4/projects/'+project_id, headers=headers)
    
    project_info = res.json()
    project_repo = project_info["web_url"]

    x["hash"] = commit_hash
    x["repo"] = project_repo

    t.append(x)

  return t

#set yesterday json tracking
# @app.route('/set', methods=['GET'])
# @auth.login_required
def yesterday_set():
  yesterday = yesterday_get()
  f = open("json/"+str(yesterday)+".json", "r")
  d = json.load(f)
  f.close()

  for key, value in yesterday_get_tracking().items():
    print key, value
    if key in d["info"]:
      d["info"][key] += value

  print yesterday_get_commits()

  commits = yesterday_get_commits()
  if len(commits) != 0:
    for commit in commits:
      d["commits"].append(commit)

  f = open("json/"+str(yesterday)+".json", "w+")
  f.write(json.dumps(d))
  f.close()
  update_file(yesterday+".json", "json/", "Set data for day: "+yesterday)

def git_init():
  gl = gitlab.Gitlab('https://gitlab.com/', private_token=secrets["token"])
  gl.auth()
  return gl

def git_get_project():
  gl = git_init()
  project = gl.projects.get(11960084) #days
  return project

def git_create_file(filename, directory):
    data = {
    'branch': 'master',  # v4
    'commit_message': 'Created file: '+filename,
    'actions': [
      {
        'action': 'create',
        'file_path': directory+filename,
        # 'file_path': 'csv/test.csv',
        'content': open(directory+filename).read(),
      },
    ]
  }
  project = git_get_project()
  commit = project.commits.create(data)
  print("Created")

def git_update_file(filename, directory):
  data = {
    'branch': 'master',  # v4
    'commit_message': 'Updated file: '+filename,
    'actions': [
      {
        'action': 'update',
        'file_path': directory+filename,
        # 'file_path': 'csv/test.csv',
        'content': open(directory+filename).read(),
      },
    ]
  }
  project = git_get_project()
  commit = project.commits.create(data)
  print("Committed")


def pull_files():



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