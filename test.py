import os
import csv
import operator

lst = os.listdir("csv/")
lst = sorted(lst)
getLongestDay(lst)
