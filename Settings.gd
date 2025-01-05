extends VBoxContainer


func _ready():
	$filepath/showpath.text = Options.filepath
	
	
	$interval/number.text = str(Options.autosaveinterval)
	
	#stupid convert the things to actual color values
	var skycolor = Color.hex(Options.skycolor.hex_to_int())
	$"sky color/color".color = Color(skycolor[1],skycolor[2],skycolor[3],1)
	
	var voidcolor = Color.hex(Options.voidcolor.hex_to_int())
	$"void color/color".color = Color(voidcolor[1],voidcolor[2],voidcolor[3],1)


func _on_filepath_pressed():
	$filepath/FileDialog.popup()

func _on_file_dialog_dir_selected(dir):
	Options.filepath = dir
	$filepath/showpath.text = dir
