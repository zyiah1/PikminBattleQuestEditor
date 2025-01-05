class_name Fmpobject extends Node3D


@export var Name: String = "Zld_Tsubo"
@export var Param0: int = -1
@export var Param1: int = -1
@export var Param10: int = -1
@export var Param11: int = -1
@export var Param2: int = -1
@export var Param3: int = -1
@export var Param4: int = -1
@export var Param5: int = -1
@export var Param6: int = -1
@export var Param7: int = -1
@export var Param8: int = -1
@export var Param9: int = -1

@export var Hitbox: PackedScene = preload("res://Hitboxes/Default.tscn")
@export var Scalable: bool = false
@export var Rotatable: bool = true


@onready var creator = Options.creator
@onready var id = Options.creator.idnum


var load = false
var hovered = false

@onready var data = [
"          - PathID: -1.00000",
"            comment: !l -1",
"            dir_x: "+str(rotation.x),
"            dir_y: "+str(rotation.y),
"            dir_z: "+str(rotation.z),
"            group: 0.00000",
"            id_name: obj"+str(id),
"            layer: L1",
"            link_info: []",
"            link_num: !l 0",
"            name: " + Name,
"            param0: "+str(Param0),
"            param1: "+str(Param1),
"            param10: "+str(Param10),
"            param11: "+str(Param11),
"            param2: "+str(Param2),
"            param3: "+str(Param3),
"            param4: "+str(Param4),
"            param5: "+str(Param5),
"            param6: "+str(Param6),
"            param7: "+str(Param7),
"            param8: "+str(Param8),
"            param9: "+str(Param9),
"            pos_x: "+str(position.x),
"            pos_y: "+str(position.y),
"            pos_z: "+str(position.z),
"            scale_x: "+str(scale.x),
"            scale_y: "+str(scale.y),
"            scale_z: "+str(scale.z)
]



func _ready():
	Options.creator.idnum += 1
	var inst = Hitbox.instantiate()
	inst.connect("area_entered",Callable(self,"area_entered"))
	inst.connect("area_exited",Callable(self,"area_exited"))
	add_child(inst)
	if load == true:
		reposition()


func area_entered(area):
	hovered = true
	hide()

func area_exited(area):
	hovered = false
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered == true:
		if Input.is_action_just_pressed("Click"):
			match creator.item:
				"delete":
					creator.objnodes.remove_at(creator.objnodes.find(self))
					queue_free()
				"property":
					refreshData()
					creator.parse(data)
					creator.editedNode = self
				"inspect":
					if is_in_group("SwitchBox"):
						for nodes in Options.creator.get_node("Objects").get_children():
							if not nodes.is_in_group("SwitchBox"):
								if not nodes.Param1 == Param1:
									nodes.hide()
								else:
									nodes.show()
				"move":
					var toolinst = preload("res://AxisforTools/Move.tscn").instantiate()
					#toolinst.connect("x",Callable(self,"xclicked"))
					#add_child(toolinst)
					

func xclicked():
	pass

func reposition():
	if data.size() > 25:
		position = Vector3(float(data[23].lstrip("            pos_x: ")),float(data[24].lstrip("            pos_y: ")),float(data[25].lstrip("            pos_z: ")))
		if Rotatable:
			rotation_degrees = Vector3(float(data[2].lstrip("            dir_x: ")),float(data[3].lstrip("            dir_y: ")),float(data[4].lstrip("            dir_z: ")))
		if Scalable:
			scale = Vector3(float(data[26].lstrip("            scale_x: ")),float(data[27].lstrip("            scale_y: ")),float(data[28].lstrip("            scale_z: ")))
		var oldname = Name
		Name = data[10].lstrip("            name: ")
		Param0 = int(data[11].lstrip("            param0: "))
		Param1 = int(data[12].lstrip("            param1: "))
		Param10 = int(data[13].lstrip("            param10: "))
		Param11 = int(data[14].lstrip("            param11: "))
		Param2 = int(data[15].lstrip("            param2: "))
		Param3 = int(data[16].lstrip("            param3: "))
		Param4 = int(data[17].lstrip("            param4: "))
		Param5 = int(data[18].lstrip("            param5: "))
		Param6 = int(data[19].lstrip("            param6: "))
		Param7 = int(data[20].lstrip("            param7: "))
		Param8 = int(data[21].lstrip("            param8: "))
		Param9 = int(data[22].lstrip("            param9: "))
		id = int(data[6].lstrip("            id_name: obj"))
		refreshData() #allows the pot to update
		if oldname != Name:
			var instance = null
			match Name:
				"Zld_Tsubo":
					instance = load("res://Zelda/Actors/Scenes/zld_tsubo.tscn").instantiate()
				"Zld_GoalPos":
					instance = load("res://Zelda/Actors/Goal.tscn").instantiate()
				"Zld_Moriburin_C":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_C.tscn").instantiate()
				"Zld_Moriburin_B":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_B-C.tscn").instantiate()
				"Zld_Moriburin_A":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_A.tscn").instantiate()
				"Zld_Moriburin_S":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_S.tscn").instantiate()
				"Zld_Moriburin_SS":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_SS.tscn").instantiate()
				"Zld_Chuchu":
					instance = load("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu.tscn").instantiate()
				"Zld_Chuchu_A":
					instance = load("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu_A.tscn").instantiate()
				"Zld_StartPos":
					instance = load("res://Zelda/Actors/Start.tscn").instantiate()
				"Zld_Crowly":
					instance = load("res://Zelda/Actors/Scenes/Zld_Crowly.tscn").instantiate()
				"Zld_Yumiburin":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Yumiburin.tscn").instantiate()
				"Zld_Hayaburin":
					instance = load("res://Zelda/Actors/Bokoblin/Scenes/Zld_Hayaburin.tscn").instantiate()
				"Zld_Bakudan_A":
					instance = load("res://Zelda/Actors/Scenes/Zld_Bakudan_A.tscn").instantiate()
				"Zld_StartSwitchBox":
					instance = load("res://Zelda/Triggers/StartSwitchBox.tscn").instantiate()
				"Zld_AppearSwitchBox":
					instance = load("res://Zelda/Triggers/AppearSwitchBox.tscn").instantiate()
			
			if instance != null:
				get_parent().add_child(instance)
				instance.position = position
				instance.rotation = rotation
				instance.scale = scale
				creator.objnodes[creator.objnodes.find(self)] = instance
				instance.Param0 = Param0
				instance.Param1 = Param1
				instance.Param10 = Param10
				instance.Param11 = Param11
				instance.Param2 = Param2
				instance.Param3 = Param3
				instance.Param4 = Param4
				instance.Param5 = Param5
				instance.Param6 = Param6
				instance.Param7 = Param7
				instance.Param8 = Param8
				instance.Param9 = Param9
				instance.id = id
				instance.refreshData()
				creator.editedNode = instance
				queue_free()

func refreshData():
	if Name.contains("Moriburin"):
		if Param4 == 1:
			$Pot.show()
		else:
			$Pot.hide()
	data = [
"          - PathID: -1.00000",
"            comment: !l -1",
"            dir_x: "+str(rotation.x),
"            dir_y: "+str(rotation.y),
"            dir_z: "+str(rotation.z),
"            group: 0.00000",
"            id_name: obj"+str(id),
"            layer: L1",
"            link_info: []",
"            link_num: !l 0",
"            name: " + Name,
"            param0: "+str(Param0),
"            param1: "+str(Param1),
"            param10: "+str(Param10),
"            param11: "+str(Param11),
"            param2: "+str(Param2),
"            param3: "+str(Param3),
"            param4: "+str(Param4),
"            param5: "+str(Param5),
"            param6: "+str(Param6),
"            param7: "+str(Param7),
"            param8: "+str(Param8),
"            param9: "+str(Param9),
"            pos_x: "+str(position.x),
"            pos_y: "+str(position.y),
"            pos_z: "+str(position.z),
"            scale_x: "+str(scale.x),
"            scale_y: "+str(scale.y),
"            scale_z: "+str(scale.z)
]

func EXPORT():
	refreshData()
	creator.objects += data
