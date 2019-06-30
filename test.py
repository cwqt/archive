import os
import csv
import operator

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

	x = max(c.iteritems(), key=operator.itemgetter(1))[0]
	return x

lst = os.listdir("csv/")
lst = sorted(lst)
getLongestDay(lst)
