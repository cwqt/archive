#!flask/bin/python
from flask import Flask, jsonify, make_response, request, json
from flask_httpauth import HTTPBasicAuth
import json
import os
from flask_cors import CORS
import csv
import operator


app = Flask(__name__)
auth = HTTPBasicAuth()
CORS(app)

#heroku/local checking
is_prod = os.environ.get('IS_HEROKU', None)
secrets = ""
if is_prod:
  secrets = {
    "username": os.environ.get('SECRETS_USERNAME'),
    "password": os.environ.get('SECRETS_PASSWORD'),
    "token":    os.environ.get('SECRETS_TOKEN')
  } 
  print(secrets)
else:
  secrets = json.load(open("secrets.json"))

def getHoursFromDay(filename):
  filename, ext = os.path.splitext(filename)
  #get tracking info from csv
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
  return t

def getSumOfHours(filename):
  filename, ext = os.path.splitext(filename)
  s = 0
  stats = getHoursFromDay(filename)
  for key, value in stats.items():
    s += value
  return s

def getLongestDay(lst):
  c = {}
  for filename in lst:
    totalHours = getSumOfHours(filename)
    c[filename] = totalHours

  print(c)
  x = max(c.items(), key=operator.itemgetter(1))[0]
  return x

@app.route('/days/total', methods=['GET'])
def get_days_total():
  t = []
  n = 0
  for filename in os.listdir("json/"):
    n += 1
  print(n)
  return str(n)
  # return make_response(jsonify(n), 200)

@app.route('/days/hours', methods=['GET'])
def get_hours_total():
  t = []
  n = 0
  for filename in os.listdir("json/"):
    f = open("json/"+filename, "r")
    v = json.load(f)
    f.close()
    for key, value in v["info"].items():
      n += value
  n = round(n, 2)
  return str(n)
  # return make_response(jsonify(n), 200)

@app.route('/days/longest', methods=['GET'])
def get_longest_day():
  lst = os.listdir("csv/")
  lst = sorted(lst)
  x = getLongestDay(lst)
  y = getSumOfHours(x)
  return str(y)

@app.route('/days', methods=['GET'])
def get_all_days():
  t = []
  for filename in sorted(os.listdir("json/")):
    print(filename)
    f = open("json/"+filename, "r")
    v = json.load(f)
    f.close()
    t.append(v)
  return make_response(jsonify(t), 200)

@app.route('/days/<string:day_id>', methods=['GET'])
def get_day(day_id):
  exists = os.path.isfile('json/'+str(day_id)+".json")
  if exists:
    f = open("json/"+str(day_id)+".json", "r")
    v = json.load(f)
    f.close()
    print(v)
    return make_response(jsonify(v), 200)
  else:
    return make_response(jsonify({"success":False}), 404)

