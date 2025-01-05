extends Button

var Path
@onready var Map = get_parent().get_parent().get_parent().get_parent().get_node("Map")

func _ready():
	if str(Path).contains("Sougen"):
		theme = preload("res://Themes/Buttons/MapbuttonGrass.tres")

func _pressed():
	for node in Map.get_children():
		node.queue_free()
	var instance = load(Path).instantiate()
	Map.add_child.call_deferred(instance)
