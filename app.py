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
  secrets = {"username":os.environ.get('SECRETS_USERNAME'), "password":os.environ.get('SECRETS_PASSWORD'), "token":os.environ.get('SECRETS_TOKEN')} 
  print(secrets)
else:
  secrets = json.load(open("secrets.json"))

@app.route('/days/<string:day_id>', methods=['GET'])
def get_day(day_id):
	exists = os.path.isfile('json'+str(day_id)+".json")
	if exists:
	  f = open("json/"+str(day_id)+".json", "r")
	  v = json.load(f)
	  f.close()
	  return make_response(v, 200)
	else:
	  return make_response(jsonify({"success":False}), 404)

