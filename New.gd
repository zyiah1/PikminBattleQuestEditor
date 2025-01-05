extends Button


func _pressed():
	get_tree().change_scene_to_packed(preload("res://creator.tscn"))
