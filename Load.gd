extends Button

var path = "res://test.txt"
var content = ""
var world = preload("res://creator.tscn")
var loaded = false

func _pressed():
	$FileDialog.current_dir = Options.filepath
	$FileDialog.popup()

func _process(delta):
	#sets the visibility to if you have valid level data
	$Paste.visible = bool(str(DisplayServer.clipboard_get()).begins_with("Version:"))
	if Input.is_action_just_pressed("Paste"):
		content = str(DisplayServer.clipboard_get())
		LoadLevel("")

func _on_paste_button_down():
	content = str(DisplayServer.clipboard_get())
	LoadLevel("")

#just testing things in ready
func _ready():
	#print("blahblah1"[8])
	print("param1: 1".lstrip("param1:"))
	#$FileDialog.defaul

func start():
	
	
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	
	var name = str(path).get_file().left(str(path).get_file().length() - 1)
	name = name.left(name.length() - 1)
	name = name.left(name.length() - 1)
	name = name.left(name.length() - 1)
	content = file.get_as_text()
	
	file.close()
	
	content = str(content)
	
	print(name)
	
	LoadLevel(name)

var TrackedData = []
var objtracking = false
var lastnode = null

func roundvector3(vector: Vector3, step: float = 0.00001):
	var newvector = vector
	newvector.x = snapped(newvector.x,step)
	newvector.y = snapped(newvector.y,step)
	newvector.z = snapped(newvector.z,step)
	return newvector

func LoadLevel(name):
	if loaded == false:
		for nodes in get_tree().get_nodes_in_group("delete"):
			nodes.queue_free()
		content = content.split("\n")
		var cycle = 8
		
		get_node("../New").hide()
		get_node("../Settings").hide()
		hide()
		
		
		get_parent().add_child(world.instantiate())
		
		var scene = get_parent().get_node("Creator")
		scene.get_node("Camera3D").current = true
		scene.get_node("UI/name").text = name
		var nextid = 0
		var overide = 0
		if content[0] != "Version: 1":
			print("invalid")
			return
		for line in content.size():
			#keep original data for objects (commented; find better method)
			#if content[0].begins_with("          - PathID:") or content[0].begins_with("          - comment"):
			#	objtracking = true
			#if objtracking == true:
			#	TrackedData.append(content[0])
			#if content[0].begins_with("            scale_z:"):
			#	objtracking = false
			#	if lastnode != null:
			#		print("ADDED ZE DATA UREHEHHEHEHEHE")
			#		lastnode.data = TrackedData
			#	TrackedData = []
			#to account for abnoralities such as - dir or id:
			var cycleoffset = 0 #changes cycle offset
			overide = 0
			cycle -= 1
			if cycle + 1 > 0:
				content.remove_at(0)
			else:
				if content[0].begins_with("            - Points:"):
					var pointindexes = [] #where each point data is starting at  id_name
					var loops = 0
					var pointcycle = 0 #current cycle is the first
					var railinst = preload("res://Zelda/Rails/Pathrail.tscn").instantiate()
					
					
					for data in content:
						if data.begins_with("                  pnt0_x:"):
							pointindexes.append(loops)
						if data.begins_with("                - dir"):
							cycleoffset -= 1
						if data.begins_with("              name:"):
							if data.contains("レール"): #the other one i found was 未入力
								railinst = preload("res://Zelda/Rails/Rail.tscn").instantiate()
							#set all of the rail things while we are here
							railinst.Name = data.lstrip("              name: ")
							railinst.Param0 = int(content[loops+2].lstrip("              param0: "))
							railinst.Param1 = int(content[loops+3].lstrip("              param1: "))
							railinst.Param2 = int(content[loops+4].lstrip("              param2: "))
							railinst.Param3 = int(content[loops+5].lstrip("              param3: "))
							railinst.Param4 = int(content[loops+6].lstrip("              param4: "))
							railinst.Param5 = int(content[loops+7].lstrip("              param5: "))
							railinst.Param6 = int(content[loops+8].lstrip("              param6: "))
							railinst.Param7 = int(content[loops+9].lstrip("              param7: "))
							railinst.Param8 = int(content[loops+10].lstrip("              param8: "))
							railinst.Param9 = int(content[loops+11].lstrip("              param9: "))
							break
						loops += 1
					scene.get_node("Rails").add_child(railinst)
					scene.connect("EXPORT",Callable(railinst,"EXPORT"))
					var totalpoints = pointindexes.size()
					for amount in totalpoints:
						if content[pointindexes[pointcycle]].begins_with("                  pnt0_x"):
							var point = railinst.Point
							var pointinst = point.instantiate()
							#do stuff with all the points
							#print(content[13+(pointcycle)*24+pointoffsets[pointcycle]])
							var x = content[pointindexes[pointcycle]]
							var y = content[pointindexes[pointcycle]+1]
							var z = content[pointindexes[pointcycle]+2]
							#var dirx = content[3+(pointcycle)*24+pointoffsets[pointcycle]]
							#var diry = content[4+(pointcycle)*24+pointoffsets[pointcycle]]
							#var dirz = content[5+(pointcycle)*24+pointoffsets[pointcycle]]
							
							railinst.add_child(pointinst)
							railinst.pointnodes.append(pointinst)
							pointinst.position = Vector3(float(x.lstrip("                  pnt0_x: ")),float(y.lstrip("                  pnt0_y: ")),float(z.lstrip("                  pnt0_z: ")))
							pointinst.position = roundvector3(pointinst.position)
							#pointinst.rotation = Vector3(float(x.lstrip("                  dir_x: ")),float(y.lstrip("                  dir_y: ")),float(z.lstrip("                  dir_z: ")))
							#print("CURRENT: ",pointcycle)
							pointcycle += 1
							
						#else:
							#print(content[13+(pointcycle)*24])
							#points = 0
					railinst.linesetup()
					print("totalpoints: ",totalpoints)
					cycle = (totalpoints)*24+21+cycleoffset
					print(cycle," offset: ",cycleoffset)
				
				var offset = 0
				
				if content[0].begins_with("          - comment:"):
					offset = 2
				if content[0].begins_with("          - PathID:") or offset != 0:
					var inst = null
					if content[10-offset].begins_with("            name:"):
						cycle = 29-offset
					if content[10-offset].begins_with("            name: Zld_GoalPos"):
						print("NO WAY A GOAL")
						inst = preload("res://Zelda/Actors/Goal.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Moriburin_C"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_C.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Moriburin_B"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_B-C.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Moriburin_A"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_A.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Moriburin_S"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_S.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Moriburin_SS"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Moriburin_SS.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Chuchu"):
						inst = preload("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Chuchu_A"):
						inst = preload("res://Zelda/Actors/Chuchu/Scenes/Zld_Chuchu_A.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Tsubo"):
						inst = preload("res://Zelda/Actors/Scenes/zld_tsubo.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_StartPos"):
						inst = preload("res://Zelda/Actors/Start.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Crowly"):
						inst = preload("res://Zelda/Actors/Scenes/Zld_Crowly.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Yumiburin"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Yumiburin.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Hayaburin"):
						inst = preload("res://Zelda/Actors/Bokoblin/Scenes/Zld_Hayaburin.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_Bakudan_A"):
						inst = preload("res://Zelda/Actors/Scenes/Zld_Bakudan_A.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_StartSwitchBox"):
						inst = preload("res://Zelda/Triggers/StartSwitchBox.tscn").instantiate()
					if content[10-offset].begins_with("            name: Zld_AppearSwitchBox"):
						inst = preload("res://Zelda/Triggers/AppearSwitchBox.tscn").instantiate()
					
					
					
					if inst != null:
						print(content[10-offset])
						scene.connect("EXPORT", Callable(inst, "EXPORT"))
						
						inst.position = roundvector3(Vector3(float(content[23-offset].lstrip("            pos_x:")),float(content[24-offset].lstrip("            pos_y:")),float(content[25-offset].lstrip("            pos_z:"))))
						inst.rotation_degrees = roundvector3(Vector3(float(content[2-offset].lstrip("            dir_x:")),float(content[3-offset].lstrip("            dir_y:")),float(content[4-offset].lstrip("            dir_z:"))))
						inst.scale = roundvector3(Vector3(float(content[26-offset].lstrip("            scale_x:")),float(content[27-offset].lstrip("            scale_y:")),float(content[28-offset].lstrip("            scale_z:"))))
						inst.Param0 = int(content[11-offset].lstrip("            param0:"))
						inst.Param1 = int(content[12-offset].lstrip("            param1:"))
						if content[12-offset] == "            param1: 1.00000":
							inst.Param1 = 1
						print(inst.Param1,content[12-offset][20])
						inst.Param10 = int(content[13-offset].lstrip("            param10:"))
						inst.Param11 = int(content[14-offset].lstrip("            param11:"))
						inst.Param2 = int(content[15-offset].lstrip("            param2:"))
						inst.Param3 = int(content[16-offset].lstrip("            param3:"))
						inst.Param4 = int(content[17-offset].lstrip("            param4:"))
						inst.Param5 = int(content[18-offset].lstrip("            param5:"))
						inst.Param6 = int(content[19-offset].lstrip("            param6:"))
						inst.Param7 = int(content[20-offset].lstrip("            param7:"))
						inst.Param8 = int(content[21-offset].lstrip("            param8:"))
						inst.Param9 = int(content[22-offset].lstrip("            param9:"))
						scene.get_node("Objects").add_child(inst)
						scene.objnodes.append(inst)
						cycle = 29-offset
						lastnode = inst
			if cycle < 0:
				print("ERR Not Recognized:" + content[0])
				content.remove_at(0)
		
		
		scene.load = true
		loaded = true
	



func _on_file_dialog_file_selected(input):
	path = input
	start()
