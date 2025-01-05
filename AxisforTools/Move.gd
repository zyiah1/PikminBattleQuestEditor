extends Node3D

signal x
signal y
signal z
#signals to tell object when a certain axis is held


var xhover = false
var yhover = false
var zhover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Click"):
		if xhover == true:
			emit_signal("x")


func _on_x_area_entered(area):
	xhover = true


func _on_x_area_exited(area):
	xhover = false
