extends Button


func _ready() -> void:
	$".".connect("pressed", _on_jouer_pressed)

func _on_jouer_pressed():
	NightManager.SetNight(1)
	$"../../Transition".ShowNightTransition()
