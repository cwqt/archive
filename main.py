#!/usr/bin/env python2
#run once per day when terminal starts
#json
#csv

#iterate through csvs
#create json files (if one exists)
#add commits
#add tracking

import os
import json
import csv
import requests
import gitlab
import copy
from datetime import datetime, timedelta

class color:
   BOLD = '\033[1m'
   END = '\033[0m'

secrets = json.load(open("secrets.json"))

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

cnt = 0   # 
cnt2 = 0  # total csvs
for filename in os.listdir("csv/"):
  cnt2 += 1 
  f, e = os.path.splitext(filename)
  exists = os.path.isfile('json/'+f+".json")
  if not exists:
    cnt += 1

print(cnt, cnt2)

cnt = str(cnt)
cnt2 = str(cnt2)

if cnt == cnt2:
  print("All caught up! ("+color.BOLD+cnt+"/"+cnt2+color.END+").")
else:
  print("Catching up on "+color.BOLD+cnt+"/"+cnt2+color.END+" unwritten files.")
  for filename in os.listdir("csv/"):
    filename, ext = os.path.splitext(filename)
    exists = os.path.isfile('json/'+filename+".json")  
    if not exists:
      #create a json file
      fo = open("json/"+filename+".json", "w")
      filebuffer = [""]
      fo.writelines(filebuffer)
      fo.close()

      #instantiate a day data
      day_data = copy.deepcopy(day)
      print(color.BOLD + filename + color.END)

      #get the commits from that day via gitlab
      print("\tGetting commits...")
      # $ curl --header "PRIVATE-TOKEN: <token>" -X GET 'https://gitlab.com/api/v4/events?action_type=pushed&after=2019-04-21&before=2019-04-22'
      datetime_object = datetime.strptime(filename, '%Y-%m-%d')
      date_minus1 = datetime.strftime(datetime_object - timedelta(1), '%Y-%m-%d')
      date_plus1 = datetime.strftime(datetime_object + timedelta(1), '%Y-%m-%d')

      headers = {'PRIVATE-TOKEN': secrets["token"]}
      res = requests.get('https://gitlab.com/api/v4/events?action_type=pushed&after='+date_minus1+'&before='+date_plus1, headers=headers)
      commits = res.json()
      # print(json.dumps(commits, indent=2))
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

        day_data["commits"].append(x)

      #get tracking info from csv
      print("\tGetting tracking data...")
      t = {}
      csv_file = open("csv/"+ filename +".csv")
      csv_reader = csv.reader(csv_file, delimiter=',')
      next(csv_reader, None)  # skip the headers
      #get time spent in each TimeSink 'pool'
      for row in csv_reader:
        # in seconds
        starttime = float(row[1].replace(',', ''))
        endtime = float(row[2].replace(',', ''))
        hours = (endtime-starttime)*0.000277778
        print hours
        if not row[0] in t:
          t[row[0]] = 0
        t[row[0]] += hours

      #round data to 2d.p.
      for key, value in t.items():
        t[key] = float(format(value, '.2f'))

      #add tracking data to day_data
      for key, value in t.items():
        print(key, value)
        if key in day_data["info"]:
          day_data["info"][key] += value

      #write the day template to it
      print("\tWriting to file "+filename+".json")
      with open('json/'+filename+".json", 'w') as outfile:
        json.dump(day_data, outfile)

  #execute push
  print("\n")
  os.system('git pull origin master')
  print(color.BOLD+"Pushing data..."+color.END)
  os.system('git add .')
  os.system('git commit -am "days::Catch up on '+cnt+'/'+cnt2+' files."')
  os.system("git push origin master")


  #netlify build
  print(color.BOLD+"Sending netlify build request..."+color.END)
  # curl -X POST -d {} https://api.netlify.com/build_hooks/5a3127c1a6188f469c8ff73c
  res = requests.post('https://api.netlify.com/build_hooks/5a3127c1a6188f469c8ff73c', data={})

  print(color.BOLD+"Finished."+color.END)
