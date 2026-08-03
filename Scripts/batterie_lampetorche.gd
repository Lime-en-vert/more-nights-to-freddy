extends TextureProgressBar

var counting:int = 0
var timing:float = 0

func _ready() -> void:
	NightManager.connect("CurrentEnergyLamp", _energylamp)

func _energylamp(energy: float):
	value = energy
