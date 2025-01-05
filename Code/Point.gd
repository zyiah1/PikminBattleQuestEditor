class_name Fmprailpoint extends Node3D



@export var Param0: int = -1
@export var Param1: int = -1
@export var Param2: int = -1
@export var Param3: int = -1


@export var Hitbox: PackedScene = preload("res://Hitboxes/Default.tscn")
@export var Point: PackedScene = preload("res://Points/Default.tscn")
@export var Scalable: bool = false
@export var Rotatable: bool = true


@onready var creator = Options.creator
@onready var railid = Options.creator.idnum

var pointid = 0

var hovered = false

@onready var data = [
"                - comment: !l -1",
"                  dir_x: "+str(rotation.x),
"                  dir_y: "+str(rotation.y),
"                  dir_z: "+str(rotation.z),
"                  id: 0.00000",
"                  id_name: rail"+str(railid)+"/"+str(pointid),
"                  link_info: []",
"                  link_num: !l 0",
"                  param0: "+str(Param0),
"                  param1: "+str(Param1),
"                  param2: "+str(Param2),
"                  param3: "+str(Param3),
"                  pnt0_x: "+str(position.x),
"                  pnt0_y: "+str(position.y),
"                  pnt0_z: "+str(position.z),
"                  pnt1_x: "+str(position.x),
"                  pnt1_y: "+str(position.y),
"                  pnt1_z: "+str(position.z),
"                  pnt2_x: "+str(position.x),
"                  pnt2_y: "+str(position.y),
"                  pnt2_z: "+str(position.z),
"                  scale_x: 1.00000",
"                  scale_y: 1.00000",
"                  scale_z: 1.00000",
"                  unit_name: Point"
]



func _ready():
	Options.creator.idnum += 1
	
	



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

func reposition():
	if data.size() > 25:
		position = Vector3(float(data[23].lstrip("            pos_x: ")),float(data[24].lstrip("            pos_y: ")),float(data[25].lstrip("            pos_z: ")))
		if Rotatable:
			rotation = Vector3(float(data[2].lstrip("                  dir_x: ")),float(data[3].lstrip("                  dir_y: ")),float(data[4].lstrip("                  dir_z: ")))
		if Scalable:
			scale = Vector3(float(data[26].lstrip("            scale_x: ")),float(data[27].lstrip("            scale_y: ")),float(data[28].lstrip("            scale_z: ")))
		Param0 = int(data[11].lstrip("                  param0: "))
		Param1 = int(data[12].lstrip("                  param1: "))
		Param2 = int(data[15].lstrip("                  param2: "))
		Param3 = int(data[16].lstrip("                  param3: "))



func refreshData():
	data = [
"                - comment: !l -1",
"                  dir_x: "+str(rotation.x),
"                  dir_y: "+str(rotation.y),
"                  dir_z: "+str(rotation.z),
"                  id: 0.00000",
"                  id_name: rail"+str(railid)+"/"+str(pointid),
"                  link_info: []",
"                  link_num: !l 0",
"                  param0: "+str(Param0),
"                  param1: "+str(Param1),
"                  param2: "+str(Param2),
"                  param3: "+str(Param3),
"                  pnt0_x: "+str(position.x),
"                  pnt0_y: "+str(position.y),
"                  pnt0_z: "+str(position.z),
"                  pnt1_x: "+str(position.x),
"                  pnt1_y: "+str(position.y),
"                  pnt1_z: "+str(position.z),
"                  pnt2_x: "+str(position.x),
"                  pnt2_y: "+str(position.y),
"                  pnt2_z: "+str(position.z),
"                  scale_x: 1.00000",
"                  scale_y: 1.00000",
"                  scale_z: 1.00000",
"                  unit_name: Point"
]

func EXPORT():
	refreshData()
	creator.objects += data
