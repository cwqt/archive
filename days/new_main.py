#!/usr/bin/env python3
import os
import json
import csv
import requests
import gitlab
import copy
import time
import pprint
from datetime import datetime, timedelta

secrets = json.load(open("secrets.json"))
pp = pprint.PrettyPrinter(indent=4)

os.system("clear")

class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'

print(color.BOLD + "days" + color.END + " v0.3")

class day():
  def __init__(self, date):
    self.commits = []
    self.date = date
    self.info = {}

  def addCommit(self, commit):
    self.commits.append(commit)

  def setActivity(self, activity):
    for key, value in activity.items():
      self.info[key] = value

  def json(self):
    return json.dumps(self.__dict__)

def getDaysCommitsFromGit(date):
  commit_list = []
  datetime_object = datetime.strptime(date, '%Y-%m-%d')
  date_yesterday = datetime.strftime(datetime_object - timedelta(1), '%Y-%m-%d')
  date_tommorrow = datetime.strftime(datetime_object + timedelta(1), '%Y-%m-%d')

  headers = {'PRIVATE-TOKEN': secrets["git_user_api_key"]}
  res = requests.get('https://gitlab.com/api/v4/events?action_type=pushed&after='+date_yesterday+'&before='+date_tommorrow, headers=headers)
  commits = res.json()

  padding = ""
  if len(commits) < 10:
    padding = " "
  print("[%s%d] cmt, " % (padding, len(commits)), end='')

  if len(commits) == 0:
    return

  for commit in commits:
    if commit["action_name"] != "pushed to":
      continue

    project_id = str(commit["project_id"])
    res = requests.get('https://gitlab.com/api/v4/projects/'+project_id, headers=headers)
    project_info = res.json()

    sha = commit["push_data"]["commit_to"][:8]
    project_url = project_info["web_url"]
    message = commit["push_data"]["commit_title"]

    commit_list.append({"sha":sha, "url":project_url,"message":message})

  return commit_list

def getActivityFromCsv(date):
  csv_file = open("csv/"+ date +".csv")
  csv_reader = csv.reader(csv_file, delimiter=',')
  next(csv_reader, None)  # skip the headers

  activities = {}
  sum_time = 0
  for row in csv_reader:
    start_time = float(row[1].replace(',', ''))
    end_time   = float(row[2].replace(',', ''))

    hours = (end_time-start_time)*0.000277778
    sum_time += hours

    if not row[0] in activities:
      activities[row[0]] = 0
    activities[row[0]] += hours

  print("[%s] hrs (" % format(sum_time, '.2f'), end='')

  for activity, time in activities.items():
    print("%s:%s" % (activity[0], format(time, '.2f')), end='')
    if not activity == list(activities.keys())[-1]:
      print(", ", end='')
    activities[activity] = float(format(time, '.2f'))
  print(")", end="")

  return activities

#============================================
unwrittenDays = []

for filename in os.listdir("csv/"):
  f, e = os.path.splitext(filename)
  exists = os.path.isfile('json/'+f+".json")
  if not exists:
    unwrittenDays.append(f)

#don't write today since timesink is still adding to the csv
unwrittenDays.remove(datetime.now().strftime('%Y-%m-%d'))

if len(unwrittenDays) == 0:
  print("No days to write.")
  exit()

print("  " + color.BOLD + str(len(unwrittenDays)) + color.END + " unwritten days. ", end='')

user_gitlab = gitlab.Gitlab("https://gitlab.com", secrets["git_user_api_key"])
bot_gitlab  = gitlab.Gitlab("https://gitlab.com", secrets["git_bot_api_key"])
user_gitlab.auth()
bot_gitlab.auth()

print("(%s/%s)" % (user_gitlab.user.name, bot_gitlab.user.name))

for date in unwrittenDays:
  print("  " + color.BOLD + date + color.END + ": ", end='')
  today = day(date)
  todaysCommits = getDaysCommitsFromGit(date)
  todaysActivity = getActivityFromCsv(date)

  if todaysCommits:
    for commit in todaysCommits:
      today.addCommit(commit)
  today.setActivity(todaysActivity)

  f = open("json/"+date+".json", "w")
  filebuffer = [""]
  f.writelines(filebuffer)
  f.close()
  with open('json/'+date+".json", 'w') as outfile:
    json.dump(today.__dict__, outfile, indent=4, sort_keys=True)

os.system('git pull origin master')
os.system('git add . > /dev/null')
os.system("git -c user.email=bot@cass.si -c user.name='cxss-bot' commit -am 'days::Catch up on "+str(len(unwrittenDays))+" file(s).'")
os.system("git push origin master")