import os
from os import listdir
from os.path import isfile, join

dir_path = os.path.dirname(os.path.realpath(__file__))

onlyfiles = [f for f in listdir(dir_path) if isfile(join(dir_path, f))]

print(len(onlyfiles))

for i in onlyfiles:
	if i != "rename.py" and i[12] == t:
		print(i)

		#os.rename(i, i[:4]+"_static_target.png")