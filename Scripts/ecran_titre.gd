extends Control


func _ready():
	UpdateTitleScreen()

func UpdateTitleScreen():
	if NightManager.highest_night_reached >= 2:
		$Ecrantitre/Freddy.visible = true
	if NightManager.highest_night_reached >= 3:
		$Ecrantitre/Bonnie.visible = true
	if NightManager.highest_night_reached >= 4:
		$Ecrantitre/Chica.visible = true
	if NightManager.highest_night_reached >= 5:
		$Ecrantitre/Foxy.visible = true
		$Ecrantitre/ventilpete.visible = true
	if NightManager.highest_night_reached >= 6:
		$"Ecrantitre/Golden Freddy".visible = true
		$"Ecrantitre/ventilpete/Détail".visible = true
	if NightManager.highest_night_reached == 6:
		$"Nuit 7".visible = true
		$Extra.visible = true
