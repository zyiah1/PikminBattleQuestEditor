class_name Fmprail extends Node3D


@export var Name: String = "Zld_Tsubo"
@export var Param0: int = -1
@export var Param1: int = -1
@export var Param2: int = -1
@export var Param3: int = -1
@export var Param4: int = -1
@export var Param5: int = -1
@export var Param6: int = -1
@export var Param7: int = -1
@export var Param8: int = -1
@export var Param9: int = -1

@export var Hitbox: PackedScene = preload("res://Hitboxes/Default.tscn")
@export var Point: PackedScene = preload("res://Points/Default.tscn")
@export var Scalable: bool = false
@export var Rotatable: bool = true
@export var pathcolor: Color = Color.RED


@onready var creator = Options.creator
@onready var id = 1

var hovered = false
var pointnodes = []
var load = false

@onready var data = [
"              closed: CLOSE",
"              comment: !l -1",
"              id_name: rail"+str(id),
"              layer: LC",
"              link_info: []",
"              link_num: !l 0",
"              name: " + Name, #未入力0 name in da thingamobaob
"              no: 0.00000",
"              num_pnt: !l 3",
"              param0: "+str(Param0),
"              param1: "+str(Param1),
"              param2: "+str(Param2),
"              param3: "+str(Param3),
"              param4: "+str(Param4),
"              param5: "+str(Param5),
"              param6: "+str(Param6),
"              param7: "+str(Param7),
"              param8: "+str(Param8),
"              param9: "+str(Param9),
"              type: Linear",
"              unit_name: Path"
]

func _ready():
	Options.creator.idnum += 1
	#for node in pointnodes:
		#var inst = Hitbox.instantiate()
		#inst.connect("area_entered",Callable(self,"area_entered"))
		#inst.connect("area_exited",Callable(self,"area_exited"))
		#node.add_child(inst)



func linesetup():
	var cycle = 1
	for child in $Lines.get_children():
		child.queue_free()
	for node in pointnodes:
		if pointnodes.size()>cycle:
			$Lines.add_child(await Draw3d.line(node.position,pointnodes[cycle].position,pathcolor,0))
			
			cycle += 1
	

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

func reposition():
	if data.size() > 25:
		position = Vector3(int(data[23].lstrip("            pos_x: ")),int(data[24].lstrip("            pos_y: ")),int(data[25].lstrip("            pos_z: ")))
		if Rotatable:
			rotation = Vector3(int(data[2].lstrip("            dir_x: ")),int(data[3].lstrip("            dir_y: ")),int(data[4].lstrip("            dir_z: ")))
		if Scalable:
			scale = Vector3(int(data[26].lstrip("            scale_x: ")),int(data[27].lstrip("            scale_y: ")),int(data[28].lstrip("            scale_z: ")))
		var oldname = Name
		Name = data[10].lstrip("            name: ")
		Param0 = int(data[11].lstrip("            param0: "))
		Param1 = int(data[12].lstrip("            param1: "))
		Param2 = int(data[15].lstrip("            param2: "))
		Param3 = int(data[16].lstrip("            param3: "))
		Param4 = int(data[17].lstrip("            param4: "))
		Param5 = int(data[18].lstrip("            param5: "))
		Param6 = int(data[19].lstrip("            param6: "))
		Param7 = int(data[20].lstrip("            param7: "))
		Param8 = int(data[21].lstrip("            param8: "))
		Param9 = int(data[22].lstrip("            param9: "))
		id = int(data[6].lstrip("            id_name: obj"))
		if oldname != Name:
			var instance = null
			#match Name:
				#change into different type of rail, not object
			
			
			if instance != null:
				get_parent().add_child(instance)
				instance.position = position
				instance.rotation = rotation
				instance.scale = scale
				creator.objnodes[creator.objnodes.find(self)] = instance
				instance.Param0 = Param0
				instance.Param1 = Param1
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
	data = [
"              closed: CLOSE",
"              comment: !l -1",
"              id_name: rail"+str(id),
"              layer: LC",
"              link_info: []",
"              link_num: !l 0",
"              name: " + Name, #未入力0 name in da thingamobaob
"              no: 0.00000",
"              num_pnt: !l 3",
"              param0: "+str(Param0),
"              param1: "+str(Param1),
"              param2: "+str(Param2),
"              param3: "+str(Param3),
"              param4: "+str(Param4),
"              param5: "+str(Param5),
"              param6: "+str(Param6),
"              param7: "+str(Param7),
"              param8: "+str(Param8),
"              param9: "+str(Param9),
"              type: Linear",
"              unit_name: Path"
]

func EXPORT():
	var totalpointdata = []#all of the point's data added together
	for node in pointnodes:
		node.refreshData()
		totalpointdata += node.data
	refreshData()
	var header = ["            - Points:"]
	creator.objects += header + totalpointdata + data
