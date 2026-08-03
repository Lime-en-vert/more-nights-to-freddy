extends Button

@onready var label_nuit = $"ContinueNuit"
@onready var label_meuble = $Meuble

func _ready():
	label_nuit.visible = false
	label_meuble.visible = true
	$".".connect("pressed", Continuer)
	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)
	visible = NightManager.current_night > 1

func _on_enter():
	label_nuit.visible = true
	label_meuble.visible = false
	label_nuit.text = "Nuit " + str(NightManager.current_night)

func _on_exit():
	label_nuit.visible = false
	label_meuble.visible = true

func Continuer():
	$"../Transition".ShowNightTransition()
