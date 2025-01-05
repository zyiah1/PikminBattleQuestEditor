extends Button


func _pressed():
	Options.save()
	get_tree().change_scene_to_packed(preload("res://title.tscn"))
