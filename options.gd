extends Node

var creator = null



#savable things
var filepath = "res://"
var reducemotion = false
var theme = 0 #theme: 0 = close to ingame 1 = more boring, tool-like 2 = dark, sleek
var filetype = "txt" #Not being used   aab
var autosave = true
var autosaveinterval = 10 #seconds
#keybindings???
var skycolor = "006ee0"
var voidcolor = "14100b"



var data = [filepath,
str(reducemotion),
str(theme),
str(filetype),
str(autosave),
str(autosaveinterval),
skycolor,
voidcolor]
var firstopen = true

func refreshdata():
	data = [filepath,
str(reducemotion),
str(theme),
str(filetype),
str(autosave),
str(autosaveinterval),
skycolor,
voidcolor]

func _ready():
	print("hello world")
	var file = FileAccess.file_exists("user://Zelda.settings")
	if file:
		firstopen = false
		print("Found Settings File!")
		file = FileAccess.open("user://Zelda.settings",FileAccess.READ)
		var content = file.get_as_text().split("\n")
		
		#set the things to the file
		filepath = content[0]
		if content[1] == "true":
			reducemotion = true
		theme = int(content[2])
		filetype = content[3]
		if content[4] == "false":
			autosave = false
		autosaveinterval = int(content[5])
		skycolor = content[6]
		voidcolor = content[7]


func save():
	#print(filepath)
	refreshdata()
	var file = FileAccess.open("user://Zelda.settings",FileAccess.WRITE)
	print("Saving")
	if file:
		for line in data:
			file.store_line(line)
		file.close()
