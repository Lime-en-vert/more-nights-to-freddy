extends Control

@onready var boutonmasque:Button = $Button
@onready var masqueporte:TextureRect = $"../Masqueport"
@onready var masquepala:TextureRect = $TextureRect
@onready var masque:TextureRect = $Image
@onready var flechemasque:Label = $"../Fléche Masque"
@onready var fleche:TextureRect = $"../Fléche Masque/Image"
var batterievide : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	masqueporte.visible = false
	masquepala.visible = false
	masque.visible = true
	flechemasque.visible = false
	boutonmasque.connect("pressed", _masque)
	fleche.connect("mouse_entered", _RetireMask)
	NightManager.connect("CurrentEnergy", emptybatterymask)

func emptybatterymask(energy:int):
	if energy > 0:
		return
	batterievide = true
	if masqueporte.visible == true:
		_masque(false)
	else:
		_RetireMask(false)

func _masque(jouson:bool = true):
	if jouson == true:
		$Maskue_audio.play()
	masqueporte.visible = true
	flechemasque.visible = true
	if batterievide == true:
		$masquevideeteint.visible = true
	else:
		masquepala.visible = true
	$Masqueeteint.visible = false
	masque.visible = false
	NightManager.MasqueActif(true)

func _RetireMask(jouson:bool = true):
	if jouson == true:
		$Maskue_audio.play()
	flechemasque.visible = false
	masqueporte.visible = false
	if batterievide == true:
		$Masqueeteint.visible = true
	else:
		masque.visible = true
	masquepala.visible = false
	$masquevideeteint.visible = false
	NightManager.MasqueActif(false)
