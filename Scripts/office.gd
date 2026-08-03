extends Control
#TODO LIST
#Ecran Fin

var vues: Array[Control] = []
var ivue: int = 0
@onready var fleche_gauche = $"FlècheGauche"
@onready var fleche_droite = $"FlècheDroite"
@onready var Ventilateur = $Bureau/BoutonVentilateur
@onready var Lampetorche = $LampeTorche
@onready var Cam = $Bureau/Button
@onready var Cameras = $Cameras
@onready var desk = $Bureau
@onready var batterie = $"Batterie Générale"
@onready var batterielampe = $"BatterieLampetorche"
var lampeVide : bool = false
var batterieVide : bool = false


func _ready() -> void:
	Cam.connect("pressed",_AfficheCam)
	fleche_gauche.connect("mouse_entered", AfficheGauche)
	fleche_droite.connect("mouse_entered", AfficheDroite)
	Lampetorche.visible = false
	Cameras.visible = false
	desk.visible = true
	fleche_gauche.visible = true
	fleche_droite.visible = true
	vues.append($Bureau)
	vues.append($Masque)
	vues.append($Ventillation)
	vues.append($Porte)
	Ventilateur.visible = true
	for vue in vues:
		vue.visible = false
	vues[0].visible = true
	NightManager.connect("CurrentEnergy", emptybattery)
	NightManager.connect("CurrentEnergyLamp", lampevide)
	NightManager.connect("CurrentNight", func(x:int): $Interface/Nuit.text = "Nuit "+str(x))
	NightManager.connect("CurrentHour", func(x:int): $Interface/Heure.text = str(x)+" AM")
	NightManager.connect("EndNight", end_night_screen)
	NightManager.connect("JumpScare", jump_scare_screen)
	NightManager.StartNight()

func AfficheGauche():
	var mouse_pos := get_viewport().get_mouse_position()
	get_viewport().warp_mouse(mouse_pos + Vector2(300, 0))
	vues[ivue].visible = false
	ivue = (ivue + 1)%4
	vues[ivue].visible = true

func AfficheDroite():
	var mouse_pos := get_viewport().get_mouse_position()
	get_viewport().warp_mouse(mouse_pos - Vector2(300, 0))
	vues[ivue].visible = false
	ivue = (ivue - 1)%4
	vues[ivue].visible = true
	
func emptybattery(energy:int):
	if energy > 0:
		return
	$"Bureau/Image".visible = false
	$"Bureau/Bureaueteint".visible = true
	$Porte/Image.visible = false
	$Porte/porteeteint.visible = true
	$Ventillation/Image.visible = false
	$Ventillation/ventileteint.visible = true
	$Audio/Fan.stop()
	batterieVide = true
	if $Cameras.visible == true:
		parcam()

func _input(event):
	if event.is_action_pressed("Ventillateur") and batterieVide == false:
		if Ventilateur.visible == true:
			NightManager.StartConsommation()
			$Audio/Fan.play()
			Ventilateur.visible = false
		else:
			NightManager.StopConsommation()
			$Audio/Fan.stop()
			Ventilateur.visible = true
	if event.is_action_pressed("LampeTorche"):
		$Audio/LampeTorch.play()
		if lampeVide == false:
			if Lampetorche.visible == true:
				NightManager.LampOff()
				Lampetorche.visible = false
			else:
				NightManager.LampOn()
				Lampetorche.visible = true
	if event is InputEventMouseMotion:
		Lampetorche.position = event.position
	if event.is_action_pressed("partcam"):
		if Cameras.visible == true:
			parcam()

func lampevide(energy: float):
	if energy > 0:
		return
	lampeVide = true
	Lampetorche.visible = false

func _AfficheCam():
	NightManager.StartConsommation()
	$Audio/Cam.play()
	Cameras.visible = true
	fleche_gauche.visible = false
	fleche_droite.visible = false
	desk.visible = false
	Cameras.Bouttonencours.grab_focus()
	if $Cameras/Desactive.visible == true:
		$Cameras/Static.play()

func parcam():
	$Audio/Cam.play()
	$Cameras/Static.stop()
	NightManager.StopConsommation()
	Cameras.visible = false
	desk.visible = true
	fleche_gauche.visible = true
	fleche_droite.visible = true
	NightManager.CameraActive(0)

func _stopAudio():
	for audio in $Audio.get_children():
		audio.stop()

func end_night_screen(win:bool=true, stopaudio:bool=true):
	if stopaudio == true:
		_stopAudio()
	$EndNight.visible = true
	$"EndNight/fonddefinnuit".visible = true
	NightManager.ResetAnimatronics()
	if(win):
		$Audio/Sonnerie.play()
		$"EndNight/Heure de Fin".visible = true
	else:
		$"EndNight/GAmeovers".visible = true
	await get_tree().create_timer(10.0).timeout
	if win:
		get_tree().change_scene_to_file("res://Scenes/Ecran titre.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Ecran titre.tscn")

func jump_scare_screen(animatronic:String):
	_stopAudio()
	$"EndNight".visible = true
	$"EndNight/fonddefinnuit".visible = true
	NightManager.ResetAnimatronics()
	var jumpscare_img = get_node("EndNight/" + animatronic + "Jumpscare")
	if jumpscare_img:
		jumpscare_img.visible = true
	var jumpscare_audio = get_node("Audio/" + animatronic + "Jumpscare")
	if jumpscare_audio:
		jumpscare_audio.play()
	await get_tree().create_timer(7.0).timeout
	if jumpscare_img:
		jumpscare_img.visible = false
	end_night_screen(false, false)
