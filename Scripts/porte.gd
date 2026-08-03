extends Control
@onready var boutonlumiere:Button = $ButtonLum
@onready var boutonporte:Button = $ButtonPorte
@onready var image = $Image
var affichefreddy:bool = false
var affichebonnie:bool = false
var textureportelum = preload("res://Assets/Image/Porte.Lumières.png")
var textureporte = preload("res://Assets/Image/Porte.png")
@onready var fenetreeclairee = $"../Ventillation/Fenêtreeclairee"
@onready var boutonvert = $BoutonVert
var joueunefois:bool = false
var allume:bool = false
var fermee:bool = false
@onready var batterie = $"../Batterie Générale"
@onready var portehaute = $SubViewportContainer/SubViewport/Portehaute
@onready var portebasse = $SubViewportContainer/SubViewport/Portebasse

func _ready() -> void:
	boutonlumiere.connect("pressed", _lumiere)
	boutonporte.connect("pressed", _interactionporte)
	NightManager.connect ("CurrentEnergy", portevide)
	NightManager.connect("ClassicFreddyMove", _displayClassicFreddy)
	NightManager.connect("ClassicBonnieMove", _displayClassicBonnie)

func _process(_delta: float) -> void:
	pass
	
func _lumiere():
	if (allume == false):
		NightManager.StartConsommation()
		$Light_audio.play()
		$Bouton_audio.play()
		image.texture = textureportelum
		fenetreeclairee.visible = true
		if affichefreddy == true:
			$ClassicFreddy.visible = true
			if joueunefois == false:
				$"../Audio/someoneatdoor".play()
				joueunefois = true
		if affichebonnie == true:
			$ClassicBonnie.visible = true
			if joueunefois == false:
				$"../Audio/someoneatdoor".play()
				joueunefois = true
		allume = true
		var pos = image.position
		pos.x -= 5 
		pos.y += 5
		image.set_position(pos)
	else:
		NightManager.StopConsommation()
		$Light_audio.stop()
		$Bouton_audio.play()
		image.texture = textureporte
		fenetreeclairee.visible = false
		if affichefreddy == true:
			$ClassicFreddy.visible = false
		if affichebonnie == true:
			$ClassicBonnie.visible = false
		var pos = image.position
		pos.x += 5 
		pos.y -= 5
		image.set_position(pos)
		allume = false
		
func _interactionporte():
	$Door_audio.play()
	$Bouton_audio.play()
	if (fermee == false):
		var tween:Tween = create_tween()
		var portehpos:Vector2 = portehaute.position
		var portebpos:Vector2 = portebasse.position
		portehpos.y = -1
		portebpos.y = 171
		tween.set_parallel()
		tween.tween_property(portehaute, "position", portehpos, 0.25)
		tween.tween_property(portebasse, "position", portebpos, 0.25)
		NightManager.StartConsommation()
		NightManager.PorteOpen(false)
		boutonvert.visible = true
		fermee = true
	else:
		NightManager.StopConsommation()
		NightManager.PorteOpen(true)
		var tween:Tween = create_tween()
		var portehpos:Vector2 = portehaute.position
		var portebpos:Vector2 = portebasse.position
		portehpos.y = -170
		portebpos.y = 334
		tween.set_parallel()
		tween.tween_property(portehaute, "position", portehpos, 0.25)
		tween.tween_property(portebasse, "position", portebpos, 0.25)
		boutonvert.visible = false
		fermee = false

func portevide(energy:int):
	if energy > 0:
		return
	if (fermee == true):
		$Door_audio.play()
	if (allume == true):
		$Light_audio.stop()

func _displayClassicFreddy(cam_avant:int, cam_apres:int):
	if cam_apres == 99:
		if allume == true:
			$ClassicFreddy.visible = true
		affichefreddy = true
	if cam_avant == 99:
		$ClassicFreddy.visible = false
		affichefreddy = false
		joueunefois = false

func _displayClassicBonnie(cam_avant:int, cam_apres:int):
	if cam_apres == 99:
		if allume == true:
			$ClassicBonnie.visible = true
		affichebonnie = true
	if cam_avant == 99:
		$ClassicBonnie.visible = false
		affichebonnie = false
		joueunefois = false
