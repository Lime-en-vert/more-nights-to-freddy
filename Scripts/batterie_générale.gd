extends TextureProgressBar

@onready var couleurprogress = $"."

func _ready() -> void:
	couleurprogress.tint_progress = Color("008500")
	NightManager.connect("ConsommatorCount", countconsomation)
	NightManager.connect("CurrentEnergy", currentenergy)

func currentenergy(energy:int):
	value = energy
	if value <= 0:
		$Batterievide_audio.play()

func  countconsomation(counting:int):
	if counting == 1:
		couleurprogress.tint_progress = Color("008500")
	if counting == 2:
		couleurprogress.tint_progress = Color("00ff00")
	if counting == 3:
		couleurprogress.tint_progress = Color("ffff0f")
	if counting == 4:
		couleurprogress.tint_progress = Color("ff9c0f")
	if counting == 5:
		couleurprogress.tint_progress = Color("ff4e0f")
	if counting == 6:
		couleurprogress.tint_progress = Color("ff000f")
