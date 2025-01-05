extends ScrollContainer

var maps = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var directoryPath = "res://Zelda/Stages/Scenes"
	var extension = "tscn"
	var foundPaths = getFilePathsByExtension(directoryPath, extension)
	print(foundPaths)
	maps = foundPaths
	#get_parent().get_parent().get_node("Map").add_child.call_deferred(load(foundPaths[0][0]).instantiate())
	#Adds a button for each of the maps in the folder
	
	for x in foundPaths.size():
		var value = -x-1
		var instance = preload("res://UISCENES/Mapbutton.tscn").instantiate()
		instance.Path = foundPaths[value][0]
		instance.text = foundPaths[value][1].rstrip(".tscn")
		$HBoxContainer.add_child(instance)


func getFilePathsByExtension(directoryPath: String, extension: String, recursive: bool = true) -> Array:
	
	var dir := DirAccess.open(directoryPath)
	if dir.list_dir_begin() != OK:
		printerr("Warning: could not list contents of: ", directoryPath)
		return []
	var filePaths := []
	var fileName := dir.get_next()
	while fileName != "":
		if dir.current_is_dir():
			if recursive:
				var dirPath = dir.get_current_dir() + "/" + fileName
				filePaths += getFilePathsByExtension(dirPath, extension, recursive)
		else:
			if fileName.get_extension() == extension:
				var filePath = dir.get_current_dir() + "/" + fileName
				filePaths.append([filePath,fileName])
			fileName = dir.get_next()
	return filePaths


var expanded = true
func _on_popout_pressed():
	if expanded == true:
		$MapPlayer.play("out")
	else:
		$MapPlayer.play("in")
	expanded = not expanded
