#!/usr/bin/env python2
#run once per day when terminal starts
#skip today because TimeSink not finished recording today
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
import time
from datetime import datetime, timedelta

class color:
  BOLD = '\033[1m'
  END = '\033[0m'

secrets = json.load(open("secrets.json"))

day = {
  "commits": [
      # { "hash": "md5short", "url": "https://gitlab.com/cass/g", "message":"commit message"}
  ],
  "info": {
   "writing": 0,
   "visual": 0,
   "audio": 0
  },
  "image": "",
  "date": ""
}

cnt = 0   # 
cnt2 = 0  # total csvs
for filename in os.listdir("csv/"):
  cnt2 += 1 
  f, e = os.path.splitext(filename)
  exists = os.path.isfile('json/'+f+".json")
  if exists:
    cnt += 1

c = cnt2-cnt
cnt = str(cnt)
cnt2 = str(cnt2)
skipAll = False

if c <= 0:
  print("All caught up! ("+color.BOLD+cnt+"/"+cnt2+color.END+").")
else:
  print("Catching up on "+color.BOLD+str(c)+color.END+" unwritten file(s).")
  lst = os.listdir("csv/")
  lst = sorted(lst)
  for filename in lst:
    filename, ext = os.path.splitext(filename)
    if filename == str(datetime.now().strftime('%Y-%m-%d')):
      if c == 1:
        #don't run git push/send build requests.
        skipAll = True
      print("Skipping today: "+color.BOLD+str(filename)+color.END)
      continue

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

      #add the date to the file
      day_data["date"] = filename

      #get the events from that day via gitlab
      print("\tGetting commits...")
      # $ curl --header "PRIVATE-TOKEN: <token>" -X GET 'https://gitlab.com/api/v4/events?action_type=pushed&after=2019-04-21&before=2019-04-22'
      datetime_object = datetime.strptime(filename, '%Y-%m-%d')
      date_minus1 = datetime.strftime(datetime_object - timedelta(1), '%Y-%m-%d')
      date_plus1 = datetime.strftime(datetime_object + timedelta(1), '%Y-%m-%d')

      headers = {'PRIVATE-TOKEN': secrets["token"]}
      res = requests.get('https://gitlab.com/api/v4/events?action_type=pushed&after='+date_minus1+'&before='+date_plus1, headers=headers)
      commits = res.json()
      # print(json.dumps(commits, indent=2))
      # print("("+len(commits)+")")
      for commit in commits:
        if commit["action_name"] != "pushed to":
          continue
        x = {}
        commit_hash = commit["push_data"]["commit_to"][:8]
        commit_message = commit["push_data"]["commit_title"]
        if "days::" in commit_message:
          continue

        #get commit repo
        #$ curl --header "PRIVATE-TOKEN: <token>" -X GET 'https://gitlab.com/api/v4/projects/11960084'
        project_id = str(commit["project_id"])
        res = requests.get('https://gitlab.com/api/v4/projects/'+project_id, headers=headers)
        
        project_info = res.json()
        
        project_url = project_info["web_url"]

        x["hash"] = commit_hash
        x["url"] = project_url
        x["message"] = commit_message

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
        if not row[0] in t:
          t[row[0]] = 0
        t[row[0]] += hours

      #add tracking data to day_data
      for key, value in t.items():
        print("\t" + key + ": " + str(value))
        if key in day_data["info"]:
          day_data["info"][key] += value
      
      #round data to 2d.p.
      for key, value in day_data["info"].items():
        day_data["info"][key] = float(format(value, '.2f'))

     # #last.fm get listening time from day
      # last_fm_username = "go2twentytwo"

      # last_fm_start = datetime.strptime(date_minus1, "%Y-%m-%d")
      # last_fm_start = str(time.mktime(last_fm_start.timetuple()))
     
      # last_fm_end = datetime.strptime(date_plus1, "%Y-%m-%d")
      # last_fm_end = str(time.mktime(last_fm_end.timetuple()))

      # res = requests.get('http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user='+last_fm_username+'&api_key='+secrets["last_fm_key"]+'&format=json&from='+last_fm_start+'&to='+last_fm_end)
      # last_fm_tracks = json.loads(res.text)
      # # print(json.dumps(last_fm_tracks["recenttracks"]["track"][0], indent=2))
      # for track in last_fm_tracks["recenttracks"]["track"]:
      #   r = 'http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key='+secrets["last_fm_key"]+'&artist='+track["artist"]["#text"]+'&track='+track["name"]+'&format=json'
      #   print(r)
      #   # t = requests.get()
      #   # t = json.loads(t.text)
      #   # print(t)
      #   # print(t["duration"])
      #   exit()

      #write the day template to it
      print("\tWriting to file "+filename+".json")
      with open('json/'+filename+".json", 'w') as outfile:
        json.dump(day_data, outfile, indent=4, sort_keys=True)

  if not skipAll:
    #execute push
    print(color.BOLD+"Pulling changes..."+color.END)
    os.system('git pull origin master')
    print(color.BOLD+"Pushing data..."+color.END)
    os.system('git add .')
    os.system('git commit -am "days::Catch up on '+str(c)+' file(s)."')
    os.system("git push origin master")

    #netlify build
    #print(color.BOLD+"Sending netlify build request..."+color.END)
    # curl -X POST -d {} https://api.netlify.com/build_hooks/5a3127c1a6188f469c8ff73c
    #res = requests.post('https://api.netlify.com/build_hooks/5cc37e1cb9562f12ca6ab325', data={})

  print(color.BOLD+"Finished."+color.END)
