extends Button


func _on_file_dialog_file_selected(path):
	Options.filepath = path
	Options.save()
	Options.firstopen = false

func _pressed():
	get_tree().change_scene_to_packed(preload("res://settings.tscn"))


func _process(delta):
	if Options.firstopen == true:
		if $FileDialog.visible == false:
			$FileDialog.popup()
