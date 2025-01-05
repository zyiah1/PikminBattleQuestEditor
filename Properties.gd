extends Control
var PanelIn = false



func _on_popout_pressed():
	PanelIn = not PanelIn
	if PanelIn == true:
		$popoutAnim.play("Out")
	else:
		$popoutAnim.play("In")
