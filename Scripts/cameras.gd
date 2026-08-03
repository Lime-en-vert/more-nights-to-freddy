extends Control

var Cameraencours:TextureRect
var camera22_desactivee := false
var Bouttonencours:Button
var mini_jumpscare_en_cours = false
var cameras_cassees:Array[int] = []
var TimerReactiveCam:Timer = Timer.new()

@onready var posters:Array[TextureRect] = [$"Camera22/PosterdeGF1",
							$"Camera22/PosterdeGF2",
							$"Camera23/PosterdeGF3",
							$"Camera23/PosterdeGF4",
							$"Camera23/PosterdeGF5"]

func _ready() -> void:
	await get_tree().process_frame
	for button in $Map.get_children():
		var nom = button.name
		var split = nom.split(" ")
		var numero = int(split[1])
		button.connect("pressed", func(): _AfficheCam(numero))
	Cameraencours = $"Camera1"
	Cameraencours.visible = true
	Bouttonencours = $"Map/Cam 1"
	$Electrochoc.connect("pressed", StartElectrochoc)
	NightManager.connect("ClassicFreddyMove", _displayClassicFreddy)
	NightManager.connect("ClassicBonnieMove", _displayClassicBonnie)
	NightManager.connect("CameraCassé", casser_camera)
	NightManager.connect("ClassicChicaMove", _displayClassicChica)
	NightManager.connect("ClassicFoxyMove", _displayClassicFoxy)
	NightManager.connect("FoxyRunStart", _on_foxy_run_start)
	NightManager.connect("FoxyRunEnd", _on_foxy_porte)
	NightManager.connect("SpawnGoldenFreddy", _displayPoster) 
	TimerReactiveCam.timeout.connect(_on_timer_cam_timeout)
	TimerReactiveCam.one_shot = true
	add_child(TimerReactiveCam)
	TimerReactiveCam.wait_time = 1
	NightManager.CameraActive(1)

func _AfficheCam(numero:int):
	$Switchcam_audio.play()
	NightManager.CameraActive(numero)
	Cameraencours.visible = false
	var camRecherche = "Camera"+str(numero)
	var cam:TextureRect = get_node(camRecherche)
	if(cam == null):
		cam = $Desactive
	if numero in cameras_cassees:
		$Desactive.visible = true
		$Static.play()
	else:
		$Desactive.visible = false
		$Static.stop()
	Cameraencours = cam
	Cameraencours.visible = true
	if numero == 22 and camera22_desactivee:
		$Desactive.visible = true
		$Static.play()
	var bouton = get_node("Map/Cam "+str(numero))
	Bouttonencours = bouton
	if numero > 26:
		$"Electrochoc".visible = true
	else:
		$"Electrochoc".visible = false

func casser_camera():
	mini_jumpscare_en_cours = true
	$MiniJumpscareBonnie.visible = true
	$"../Audio/ClassicBonnieMiniJumpscare".play()
	await get_tree().create_timer(0.6).timeout
	$MiniJumpscareBonnie.visible = false
	$Static.play()
	var numero = int(Cameraencours.name.substr(6))
	mini_jumpscare_en_cours = false
	if numero not in cameras_cassees:
		cameras_cassees.append(numero)
	if Cameraencours.name == "Camera" + str(numero):
		$Desactive.visible = true

func _displayPoster(num:int):
	if num == 0:
		for poster in posters:
			poster.visible = false
	else:
		posters[num-1].visible = true

func _displayClassicFreddy(cam_avant:int, cam_apres:int):
	DesactiveCam(cam_avant, cam_apres)
	$"../Audio/bruit de pas Classic".play()
	var node_name:String
	var node:Node
	node_name = "Camera"+str(cam_avant)+"/ClassicFreddy"
	node = get_node(node_name)
	if node :
		node.visible = false
	node_name = "Camera"+str(cam_apres)+"/ClassicFreddy"
	node = get_node(node_name)
	if node :
		node.visible = true

func _displayClassicBonnie(cam_avant:int, cam_apres:int):
	DesactiveCam(cam_avant, cam_apres)
	$"../Audio/bruit de pas Classic".play()
	var node_name:String
	var node:Node
	node_name = "Camera"+str(cam_avant)+"/ClassicBonnie"
	node = get_node(node_name)
	if node :
		node.visible = false
	node_name = "Camera"+str(cam_apres)+"/ClassicBonnie"
	node = get_node(node_name)
	if node :
		node.visible = true

func _displayClassicChica(cam_avant:int, cam_apres:int):
	DesactiveCam(cam_avant, cam_apres)
	$"../Audio/bruit de pas Classic".play()
	var node_name:String
	var node:Node
	node_name = "Camera"+str(cam_avant)+"/ClassicChica"
	node = get_node(node_name)
	if node :
		node.visible = false
	node_name = "Camera"+str(cam_apres)+"/ClassicChica"
	node = get_node(node_name)
	if node :
		node.visible = true
	if cam_apres == 27:
		$"../Audio/Chica bouffe".play()
	if cam_avant == 27:
		$"../Audio/Chica bouffe".stop()

func _displayClassicFoxy(pos_avant:int, pos_apres:int):
	DesactiveCam(3, 3)
	$"../Audio/bruit de pas Classic".play()
	var node_name:String
	var node:Node
	node_name = "Camera3/CaptainFoxy"+str(pos_avant)
	node = get_node(node_name)
	if node :
		node.visible = false
	node_name = "Camera3/CaptainFoxy"+str(pos_apres)
	node = get_node(node_name)
	if node :
		node.visible = true

func _on_foxy_run_start():
	camera22_desactivee = true
	if $Camera22.visible == true and camera22_desactivee:
		DesactiveCam(22,22)
	$"../Audio/FoxyRun".play()

func _on_foxy_porte():
	$"../Audio/FoxyPètelaporte".play()
	await get_tree().create_timer(3.35).timeout
	_on_foxy_run_end()

func _on_foxy_run_end():
	camera22_desactivee = false
	var cam = int(Cameraencours.name.substr(6))
	if cam == 22:
		_on_timer_cam_timeout()

func DesactiveCam(cam_avant:int, cam_apres:int):
	if $".".visible == false:
		return
	var cam:int = int(Cameraencours.name.substr(6))
	if cam != cam_avant and cam != cam_apres:
		return
	if cam in cameras_cassees:
		return
	$Desactive.visible = true
	$Static.play()
	if(cam != 22 || !camera22_desactivee):
		TimerReactiveCam.wait_time = randf_range(0.5, 1.5)
		TimerReactiveCam.start()

func CasserCamera(numero:int):
	if numero not in cameras_cassees:
		cameras_cassees.append(numero)
	if Cameraencours.name == "Camera" + str(numero):
		TimerReactiveCam.stop()
		$Desactive.visible = true

func _on_timer_cam_timeout():
	var cam = int(Cameraencours.name.substr(6))
	if cam in cameras_cassees:
		return
	$Desactive.visible = false
	$Static.stop()

func StartElectrochoc():
	$"../Audio/Shock".play()
	NightManager.StartElectrochoc(Cameraencours.name)
