do_changes = True

gml_spr_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Project/Stick-Shooter/sprites/"
flash_spr_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Flash/src/sprites/"
project_gmx_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Project/Stick-Shooter/StickShooter.project.gmx"
sprite_file_path = "C:/Users/username/Desktop/Everything/Game Projects/StickShooter Flash/src/Sprites.as"

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

def get_flash_code_1(basename, path):
	code = \
	'\t\t[Embed(source = "<SPRPATH>")] private static const <SPRVARNAMECAPS>:Class;\n' + \
	'\t\t[Embed(source = "<XMLPATH>", mimeType = "application/octet-stream")] public static const <SPRVARNAMECAPS>_XML:Class;\n' + \
	'\t\tpublic static var <SPRVARNAME>:SpriteData;\n'
	path = path[:-6]
	sprpath = "sprites/" + path.replace(flash_spr_path,"") + ".png"
	xmlpath = sprpath[:-4] + ".xml"
	code = code.replace("<SPRPATH>",sprpath)
	code = code.replace("<XMLPATH>",xmlpath)
	code = code.replace("<SPRVARNAME>",basename.replace("spr_",""))
	code = code.replace("<SPRVARNAMECAPS>",basename.upper())
	return code

def get_flash_code_2(basename):
	code = "\t\t\t<VAL> = new SpriteData(SPR_PLAYER_IDLE_XML, <SPR>);"
	code = code.replace("SPR_PLAYER_IDLE",basename.upper())
	code = code.replace("<SPR>",basename.upper())
	code = code.replace("<VAL>","Sprites." + basename.replace("spr_",""))
	return code

#Delete the dest sprites dir files/subdirs first
for the_file in os.listdir(flash_spr_path):
	file_path = os.path.join(flash_spr_path, the_file)
	try:
		if os.path.isfile(file_path):
			os.unlink(file_path)
		elif os.path.isdir(file_path): shutil.rmtree(file_path)
	except e:
		print(e)

tree1 = ET.parse(project_gmx_path)
root1 = tree1.getroot()

#Map all sprites' names to their respective directories
node_dict = dict()	#maps sprnames to their directories

def recursive(node, curdir):

	node_dir = curdir + node.attrib["name"] + "/"

	if not os.path.exists(node_dir):
		os.makedirs(node_dir)

	for subnode in node.findall("sprites"):
		recursive(subnode, node_dir)
	for subnode in node.findall("sprite"):
		node_dict[subnode.text.replace("sprites\\","")] = node_dir

if do_changes:
	recursive(root1.find("sprites"), flash_spr_path.replace("sprites/",""))

flash_code_1 = ""
flash_code_2 = ""

for file in glob.glob(gml_spr_path + "*.gmx"):

	tree = ET.parse(file)
	root = tree.getroot()
	sprname = basename(file).split(".")[0]

	#Ignore masks, they aren't sprites
	if(sprname.startswith("mask_")):
		continue
	if not sprname in node_dict:
		continue

	xorig = root.find("xorig").text
	yorigin = root.find("yorigin").text
	bboxmode = root.find("bboxmode").text
	sepmasks = root.find("sepmasks").text
	bbox_left = root.find("bbox_left").text
	bbox_right = root.find("bbox_right").text
	bbox_top = root.find("bbox_top").text
	bbox_bottom = root.find("bbox_bottom").text
	width = root.find("width").text
	height = root.find("height").text
	frames = root.find("frames")

	#If no frames, don't process
	if(frames.text is None):
		continue

	frames_arr = []
	frames_num_arr = []

	to_path_dir = node_dict[sprname] + sprname
	imArr = ["convert"]

	num_frames = 0

	for frame in frames.iter("frame"):

		num_frames+=1

		fixed_path = frame.text.replace("images\\","")
		frames_arr.append(fixed_path)

		from_path = gml_spr_path + "images/" + fixed_path
		
		if num_frames==1:
			to_path = to_path_dir + "/" + fixed_path

		imArr.append(from_path)

		if not os.path.exists(to_path_dir):
			if do_changes:
				os.makedirs(to_path_dir)

		#shutil.copy2(from_path, to_path)

		frames_num_arr.append(frame.attrib["index"])

	flash_code_1 += get_flash_code_1(sprname, to_path) + "\n"
	flash_code_2 += get_flash_code_2(sprname) + "\n"

	imArr.append("+append")
	imArr.append(to_path[:-6] + '.png')
	#print(imArr)
	os.chdir(gml_spr_path)
	if do_changes:
		subprocess.call(imArr,shell=True)

	data = "<sprite>\n"
	data += "\t<xorigin>" + xorig + "</xorigin>\n"
	data += "\t<yorigin>" + yorigin + "</yorigin>\n"
	data += "\t<sepmasks>" + sepmasks + "</sepmasks>\n"
	data += "\t<bboxmode>" + bboxmode + "</bboxmode>\n"
	data += "\t<bbox_left>" + bbox_left + "</bbox_left>\n"
	data += "\t<bbox_right>" + bbox_right + "</bbox_right>\n"
	data += "\t<bbox_top>" + bbox_top + "</bbox_top>\n"
	data += "\t<bbox_bottom>" + bbox_bottom + "</bbox_bottom>\n"
	data += "\t<width>" + width + "</width>\n"
	data += "\t<height>" + height + "</height>\n"
	data += "\t<num_frames>" + str(num_frames) + "</num_frames>\n"
	data += "\t<frames>\n"

	for i,frame in enumerate(frames_arr):
		data += "\t\t<frame index=\"" + str(frames_num_arr[i]) + "\">" + frame + "</frame>\n"

	data += "\t</frames>\n"
	data += "</sprite>"

	#print(data)

	if do_changes:

		with open(to_path_dir + "/" + sprname + ".xml","w") as ifile:
			ifile.write(data)

flash_code_1 = "//BEGINAUTOGEN1\n" + flash_code_1 + "\t\t//ENDAUTOGEN1"
flash_code_2 = "//BEGINAUTOGEN2\n" + flash_code_2 + "\t\t\t//ENDAUTOGEN2"

gencode = ""
with open(sprite_file_path,"r") as ifile:
	gencode = ifile.read()
	gencode = re.sub(r"(//BEGINAUTOGEN1).*(//ENDAUTOGEN1)", flash_code_1, gencode, 0, re.DOTALL)
	gencode = re.sub(r"(//BEGINAUTOGEN2).*(//ENDAUTOGEN2)", flash_code_2, gencode, 0, re.DOTALL)
	print(gencode)

with open(sprite_file_path,"w") as ifile:
	ifile.write(gencode)
