extends Node3D

var moriburin_A = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_A.tscn")
var moriburin_B = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_B-C.tscn")
var moriburin_S = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_S.tscn")
var moriburin_SS = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_SS.tscn")
var yumiburin = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Yumiburin.tscn")
var chuchu = preload("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu.tscn")
var chuchu_A = preload("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu_A.tscn")
var hayaburin = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Hayaburin.tscn")
var bakudan_A = preload("res://Zelda/Actors/Scenes/Zld_Bakudan_A.tscn")
var crowly = preload("res://Zelda/Actors/Scenes/Zld_Crowly.tscn")
var tsubo = preload("res://Zelda/Actors/Scenes/zld_tsubo.tscn")

var item = "none"
var shift = false
var mode = "track"
var namefocus = false
var railnodes = []
var objnodes = []
signal EXPORT
var objects = []
var idnum = 1
var cam2 = "none"
var itemqueue = []
var editedNode = null
@onready var filename = $UI/name.text
var castposition = Vector3.ZERO


var rails = []

var map = ["Version: 1",
"IsBigEndian: True",
"SupportPaths: False",
"HasReferenceNodes: False",
"root:",
"  LayerInfos:",
"    - Infos:",
"        ObjInfo:"]

var railheader = [
"        RailInfos:",
"          PathInfo:"]

var end = ["      LayerName: LC",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L1",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L2",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L3",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L4",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L5",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L6",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L7",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L8",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L9",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L10",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L11",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L12",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L13",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L14",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L15",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L16",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L17",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L18",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L19",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L20",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L21",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L22",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L23",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L24",
"    - Infos:",
"        ObjInfo: []",
"        RailInfos:",
"          PathInfo: []",
"      LayerName: L25"]


func _ready():
	Options.creator = self

var load = false
var cycle = 0

func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var space_state = get_world_3d().direct_space_state
	
	var rayOrigin
	var rayEnd
	rayOrigin = $Camera3D.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + $Camera3D.project_ray_normal(mouse_pos) * 2000
	var parameters = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	
	var intersection = space_state.intersect_ray(parameters)
	
	for node in get_node("Previews").get_children():
		node.position = Vector3(384,394,-999)
	
	
	if not intersection.is_empty():
		var pos = intersection.position
		var inst = null
		if Input.is_action_just_pressed("Add"):
			match item:
				"moriA":
					inst = moriburin_A.instantiate()
				"moriB":
					inst = moriburin_B.instantiate()
				"moriS":
					inst = moriburin_S.instantiate()
				"moriSS":
					inst = moriburin_SS.instantiate()
				"yumi":
					inst = yumiburin.instantiate()
				"chuchu":
					inst = chuchu.instantiate()
				"chuchuA":
					inst = chuchu_A.instantiate()
				"haya":
					inst = hayaburin.instantiate()
				"bakudanA":
					inst = bakudan_A.instantiate()
				"crowly":
					inst = crowly.instantiate()
				"tsubo":
					inst = tsubo.instantiate()
		if item != "none":
			if get_node_or_null("Previews/" + item) != null:
				get_node_or_null("Previews/" + item).position = pos
		if inst != null:
			connect("EXPORT", Callable(inst, "EXPORT"))
			inst.position = pos #-Vector3(0,pos.y,0)
			$Objects.add_child(inst)
			objnodes.append(inst)
			idnum += 1 
	else:
		$Previews.hide()
	get_input(delta)
	
	

func get_input(delta):
	if Input.is_action_just_pressed("Tab"):
		$UI/Properties/Popout.grab_focus()
		$UI/Properties._on_popout_pressed()
	if Input.is_action_just_pressed("map"):
		$UI/Maps._on_popout_pressed()
	if Input.is_action_just_pressed("ui_accept"):
		$Camera3D.paused = false
		$UI/name.release_focus()
	if Input.is_action_just_pressed("Copy"):
		_on_export_pressed()
		var path
		var fakeout = false
		if $UI/name.text == "":
			$UI/name.text = "untitled"
			fakeout = true
		path = Options.filepath + "/" + $UI/name.text + ".txt"
		
		print(path)
		
		var file = FileAccess.open(path, FileAccess.READ)
		
		DisplayServer.clipboard_set(file.get_as_text())
		if fakeout == true:
			$UI/name.text = ""
	if Input.is_action_just_pressed("Export"):
		_on_export_pressed()
		if $UI/name.text == "":
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/untitled" + ".txt"))
		else:
			OS.shell_open(str("file://" + ProjectSettings.globalize_path(Options.filepath) + "/" + $nonmoving/name.text + ".txt"))
	if Input.is_action_pressed("Save"):
		$Camera3D.paused = true
		_on_export_pressed()
	else:
		$Camera3D.paused = false
	if Input.is_action_just_pressed("Shift"):
		shift = not shift
	if Input.is_action_just_pressed("Esc"):
		get_tree().change_scene_to_file("res://title.tscn")
	if Input.is_action_just_pressed("Undo"):
		if objnodes.size() != 0:
			if mode != "track":
				objnodes[objnodes.size()-1].queue_free()
				objnodes.remove_at(objnodes.size() - 1)
				
				
			


func _on_export_pressed():
	if namefocus == false:
		var prename = $UI/name.text
		if $UI/name.text == "":
			$UI/name.text = "untitled"
		filename = $UI/name.text
		$UI/name.show()
		emit_signal("EXPORT")
		
		var path = Options.filepath + "/" + $UI/name.text + ".txt"
		var file = FileAccess.open(path,FileAccess.WRITE)
		var text = map + objects + railheader + rails + end
		if file.open(Options.filepath + "test" + ".txt", file.WRITE):
			file.open(Options.filepath + "test" + ".txt", file.WRITE)
			for line in text:
				file.store_line(line)
			file.close()
			$UI/name.text = prename
		objects = []
	
	
	var t = Timer.new()
	
	t.one_shot = true
	add_child(t)
	t.start(.1)
	await(t.timeout)
	$UI/saving.hide()
	t.queue_free()

func _on_done_pressed():
	mode = "object"
	$uiAnimaiton.play("done->export")


func cam2in():
	cam2 = "in"


func cam2out():
	$Camera2.position = $Camera3D.position
	cam2 = "out"

var stored

func undo(object):
	stored = object
	




func _on_undodelay_timeout():
	stored.queue_free()





func _on_back_pressed():
	for buttons in get_tree().get_nodes_in_group("button"):
		buttons.disabled = false
	mode = "track"
	$uiAnimaiton.play("done<-export")


func onchange(newtext):
	if editedNode != null:
		var collected = []
		for nodes in get_tree().get_nodes_in_group("LineEdit"):
			collected.append(nodes.text)
		editedNode.data = collected
		print(collected)
		editedNode.reposition()

var Groupnum = 0

func parse(data):
	for nodes in get_tree().get_nodes_in_group("LineEdit"):
		nodes.queue_free()
	
	
	for line in data:
		var Edit = preload("res://UISCENES/LineEdit.tscn").instantiate()
		Edit.connect("text_changed",Callable(self,"onchange"))
		Edit.text = line
		match Groupnum:
			0:
				Edit.add_to_group("Data")
			1:
				Edit.add_to_group("End")
			2:
				Edit.add_to_group("ChildData")
			3:
				Edit.add_to_group("ChildEnd")
		$UI/Properties/ScrollContainer/VBoxContainer.add_child(Edit)
	
	Groupnum += 1
	
	#if Options.scrollbg == "true":
		#$"CanvasLayer3/Proporties Panel/Panel".play("IN")
	#else:
		#$"CanvasLayer3/Proporties Panel".show()
