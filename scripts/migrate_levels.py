gml_lvl_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Project/Stick-Shooter/rooms/"
flash_lvl_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Flash/src/levels/"


import glob
import xml.etree.ElementTree as ET
from os.path import basename
import shutil
import os
import stat
import os, shutil
import subprocess
import sys
import re

for file in glob.glob(gml_lvl_path + "*.room.gmx"):

	tree = ET.parse(file)
	root = tree.getroot()
	roomname = basename(file).split(".")[0]

	if(roomname != "room3"):
		continue

	instances = root.find("instances")

	data = "<level>\n"
	data += "\t<objects>\n"

	for instance in instances.iter("instance"):

		data += "\n\t\t<object "

		objName = instance.attrib["objName"]
		x = instance.attrib["x"]
		y = instance.attrib["y"]
		code = instance.attrib["code"]
		scaleX = instance.attrib["scaleX"]
		scaleY = instance.attrib["scaleY"]
		color = instance.attrib["colour"]
		rotation = instance.attrib["rotation"]

		data += 'type="' + objName[4:] + '" '
		data += 'x="' + x + '" '
		data += 'y="' + y + '" '
		data += 'scaleX="' + scaleX + '" '
		data += 'scaleY="' + scaleY + '" '
		data += 'color="' + color + '" '
		data += 'rotation="' + rotation + '" '

		code = code.replace(" ","")

		if "is_platform=true" in code:
			data += "is_platform=\"true\""
		else:
			data += "is_platform=\"false\""

		if "is_ladder_jp=true" in code:
			data += "is_ladder_jp=\"true\""
		else:
			data += "is_ladder_jp=\"false\""

		if "is_ladder_dp=true" in code:
			data += "is_ladder_dp=\"true\""
		else:
			data += "is_ladder_dp=\"false\""

		if "name=" in code:
			name = re.search('name="(.+?)"',code)
			data += ' name="' + name.group(1) + '"'
		data += " />"

	data += "\n\t</objects>\n"
	data += "</level>"

	#print(data)

	filename = flash_lvl_path + roomname + ".xml"

	print(filename)

	with open(filename,"w") as ifile:
		ifile.write(data)
