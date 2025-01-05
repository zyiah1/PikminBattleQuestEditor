extends Button


func _pressed():
	for node in get_tree().get_nodes_in_group("button"):
		node.disabled = false
	disabled = true
	Options.creator.item = name
	for nodes in Options.creator.get_node("Objects").get_children():
		nodes.show()
