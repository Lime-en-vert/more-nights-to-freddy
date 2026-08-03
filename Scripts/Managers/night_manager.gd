extends Node

# Les variables
var camera_active:int = 1
var current_night = 1
var highest_night_reached = 1
var night_data = {
	1: {"freddy": 0, "bonnie": 0, "chica": 0, "foxy": 0, "golden": 20},
	2: {"freddy": 1, "bonnie": 2, "chica": 1, "foxy": 0, "golden": 0},
	3: {"freddy": 3, "bonnie": 2, "chica": 2, "foxy": 1, "golden": 2},
	4: {"freddy": 4, "bonnie": 4, "chica": 5, "foxy": 3, "golden": 3},
	5: {"freddy": 6, "bonnie": 7, "chica": 6, "foxy": 5, "golden": 7},
	6: {"freddy": 8, "bonnie": 11, "chica": 9, "foxy": 7, "golden": 10}
}

var night_messages = {
	1: "Je sais que tu es là, Papa",
	2: "Dave, Tu es là aussi ?",
	3: "Les enfants sont là aussi ?",
	4: "Quel est ce bruit à l'entrée",
	5: "Il y a quelqu'un dans l'aréation",
	6: "Il n'est pas normal"
}
var show_transition := false

# Les managers
var time_manager:Node
var energy_manager:EnergyManager
var ecran_titre:Control
var classicfreddy_manager:Node
var classicbonnie_manager:Node
var classicchica_manager:ClassicChicaManager
var classicfoxy_manager:Node
var goldenfreddy_manager:Node

# Les signaux
signal CurrentNight
signal CurrentHour
signal CurrentEnergy
signal ConsommatorCount
signal EndNight
signal CurrentEnergyLamp
signal CameraCassé
signal ClassicFreddyMove
signal ClassicBonnieMove
signal ClassicChicaMove
signal ClassicFoxyMove
signal FoxyRunStart
signal FoxyRunEnd
signal Foxyalaporte
signal SpawnGoldenFreddy
signal JumpScare

func _ready() -> void:
	await get_tree().process_frame

	time_manager = preload("res://Scripts/Managers/time_manager.gd").new()
	add_child(time_manager)
	time_manager.connect("CurrentHour", _on_hour_changed)
	time_manager.connect("EndNight", _on_night_finished)

	energy_manager = preload("res://Scripts/Managers/energy_manager.gd").new()
	add_child(energy_manager)
	energy_manager.connect("CurrentEnergy", func(x):CurrentEnergy.emit(x))
	energy_manager.connect("ConsommatorCount", func(x):ConsommatorCount.emit(x))
	energy_manager.connect("CurrentEnergyLamp", func(x):CurrentEnergyLamp.emit(x))

	classicfreddy_manager = preload("res://Scripts/Managers/classicfreddy_manager.gd").new()
	add_child(classicfreddy_manager)
	classicfreddy_manager.connect("ClassicFreddyMove", func(x,y):ClassicFreddyMove.emit(x,y))
	classicfreddy_manager.connect("JumpScareClassicFreddy", func():JumpScare.emit("ClassicFreddy"))

	classicbonnie_manager = preload("res://Scripts/Managers/classicbonnie_manager.gd").new()
	add_child(classicbonnie_manager)
	classicbonnie_manager.connect("ClassicBonnieMove", func(x,y):ClassicBonnieMove.emit(x,y))
	classicbonnie_manager.connect("JumpScareClassicBonnie", func():JumpScare.emit("ClassicBonnie"))
	classicbonnie_manager.connect("CameraCassé", func():CameraCassé.emit())

	classicchica_manager = preload("res://Scripts/Managers/classicchica_manager.gd").new()
	add_child(classicchica_manager)
	classicchica_manager.connect("ClassicChicaMove", func(x,y):ClassicChicaMove.emit(x,y))
	classicchica_manager.connect("JumpScareClassicChica", func():JumpScare.emit("ClassicChica"))

	classicfoxy_manager = preload("res://Scripts/Managers/classicfoxy_manager.gd").new()
	add_child(classicfoxy_manager)
	classicfoxy_manager.connect("ClassicFoxyMove", func(x,y):ClassicFoxyMove.emit(x,y))
	classicfoxy_manager.connect("FoxyRunStart", func():FoxyRunStart.emit())
	classicfoxy_manager.connect("FoxyRunEnd", func():FoxyRunEnd.emit())
	classicfoxy_manager.connect("Foxyalaporte", func():Foxyalaporte.emit())
	classicfoxy_manager.connect("JumpScareClassicFoxy", func():JumpScare.emit("ClassicFoxy"))

	goldenfreddy_manager = preload("res://Scripts/Managers/goldenfreddy_manager.gd").new()
	add_child(goldenfreddy_manager)
	goldenfreddy_manager.connect("SpawnGoldenFreddy", func(x):SpawnGoldenFreddy.emit(x))
	goldenfreddy_manager.connect("JumpScareGoldenFreddy", func():JumpScare.emit("GoldenFreddy"))

func StartNight():
	ResetAnimatronics()
	time_manager.Reset()
	energy_manager.Reset()
	CurrentNight.emit(current_night)
	ApplyNightDifficulty()
	classicfreddy_manager.StartFreddyManager()
	classicbonnie_manager.StartBonnieManager()
	classicchica_manager.StartChicaManager()
	classicfoxy_manager.StartFoxyManager()
	time_manager.StartTimeManager()

func StartConsommation() -> void:
	energy_manager.StartConsommation()
	
func StopConsommation() -> void:
	energy_manager.StopConsommation()

func LampOn() -> void:
	energy_manager.LampOn()
	if camera_active == 3:
		classicfoxy_manager.FlashLight()

func LampOff() -> void:
	energy_manager.LampOff()


func CameraActive(num:int) -> void:
	camera_active = num
	classicfreddy_manager.CameraActive(num)
	classicbonnie_manager.CameraActive(num)
	classicfoxy_manager.UpdateTimer(num == 3)
	goldenfreddy_manager.CameraActive(num)

func MasqueActif(actif:bool) -> void:
	goldenfreddy_manager.MasqueActif(actif)

func StartElectrochoc(camera:String):
	classicchica_manager.StartElectrochoc(camera)
	
func PorteOpen(open:bool):
	classicfreddy_manager.PorteOpen(open)
	classicbonnie_manager.PorteOpen(open)
	classicfoxy_manager.PorteOpen(open)

func VentilOpen(open:bool):
	classicchica_manager.VentilOpen(open)

func SetNight(NightNumber:int):
	current_night = NightNumber

func ApplyNightDifficulty():
	if !night_data.has(current_night):
		return
	var data = night_data[current_night]
	classicfreddy_manager.SetAI(data["freddy"])
	classicbonnie_manager.SetAI(data["bonnie"])
	classicchica_manager.SetAI(data["chica"])
	classicfoxy_manager.SetAI(data["foxy"])
	goldenfreddy_manager.SetAI(data["golden"])

func _on_night_finished():
	show_transition = true
	EndNight.emit()
	if current_night < 6:
		current_night += 1
	if current_night > highest_night_reached:
		highest_night_reached = current_night

func GetNightMessage() -> String:
	return night_messages.get(current_night, "")

func _on_hour_changed(hour:int):
	CurrentHour.emit(hour)
	if hour == 2:
		classicfreddy_manager.AddAI(1)
	if hour == 3:
		classicbonnie_manager.AddAI(1)
	if hour == 4:
		classicchica_manager.AddAI(2)
	if hour == 5:
		classicfreddy_manager.AddAI(2)
		classicbonnie_manager.AddAI(2)

func ResetAnimatronics():
	classicfreddy_manager.Reset()
	classicbonnie_manager.Reset()
	classicchica_manager.Reset()
	classicfoxy_manager.Reset()
	goldenfreddy_manager.Reset()
