#!/bin/bash
git pull origin master
git add .
git commit -am "Daily push"
git push origin master
git push heroku master
