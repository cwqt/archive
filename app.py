#!flask/bin/python
from flask import Flask, jsonify, make_response, request, json
from flask_httpauth import HTTPBasicAuth
import json
import os

app = Flask(__name__)
auth = HTTPBasicAuth()

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
  print n
  return make_response(n, 200)


@app.route('/days', methods=['GET'])
def get_all_days():
  t = []
  for filename in os.listdir("json/"):
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

