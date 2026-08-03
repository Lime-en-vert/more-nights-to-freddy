extends Control
@onready var boutonventil:Button = $Button
@onready var Textboutonventil:TextureRect = $Boutonventil
@onready var batterie = $"../Batterie Générale"
@onready var portevent:TextureRect = $SubViewportContainer/SubViewport/Portevent
var fermee:bool = false


func _ready() -> void:
	boutonventil.connect("pressed", _ventilation)
	NightManager.connect ("CurrentEnergy", ventilvide)
	NightManager.connect("SpawnGoldenFreddy", _display_Goldenfreddy)
	NightManager.connect("ClassicChicaMove", _displayClassicChica)

func _ventilation():
	$Bouton_audio.play()
	$Door_audio.play()
	if (fermee == false):
		NightManager.StartConsommation()
		NightManager.VentilOpen(false)
		Textboutonventil.visible = true
		var tween:Tween = create_tween()
		var portevpos:Vector2 = portevent.position
		portevpos.y = -8
		tween.tween_property(portevent, "position", portevpos, 0.25)
		fermee = true
	else:
		NightManager.StopConsommation()
		NightManager.VentilOpen(true)
		Textboutonventil.visible = false
		var tween:Tween = create_tween()
		var portevpos:Vector2 = portevent.position
		portevpos.y = -58
		tween.tween_property(portevent, "position", portevpos, 0.25)
		fermee = false

func ventilvide(energy:int):
	if energy > 0:
		return
	if (fermee == true):
		$Door_audio.play()

func _displayClassicChica(cam_avant:int, cam_apres:int):
	if cam_apres == 99:
		$ClassicChica.visible = true
	if cam_avant == 99:
		$ClassicChica.visible = false

func _display_Goldenfreddy(num:int):
	if(num == 0):
		$GoldenFreddy.visible = false
		$"../Audio/GoldenFreddyVoice".stop()
		$"../Audio/GFLaugh".stop()
	else:
		$GoldenFreddy.visible = true
		$"../Audio/GoldenFreddyVoice".play()
		$"../Audio/GFLaugh".play()
