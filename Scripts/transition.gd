extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func ShowNightTransition():
	$"../Audio/Bouton".play()
	$".".visible = true
	$"../Ecrantitre".visible = false
	$Fond/Nuit.text = "Nuit " + str(NightManager.current_night)
	$Fond/Message.text = NightManager.GetNightMessage()
	$"../Audio/Musique".stop()
	$"../Ecrantitre/Static Camera".visible = false
	NightManager.show_transition = true
	await get_tree().create_timer(3.5).timeout
	NightManager.show_transition = false
	get_tree().change_scene_to_file("res://Scenes/Office.tscn")
