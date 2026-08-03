extends Node
class_name EnergyManager

# Les variables
var _current_energy:int = 100
var _consommator_count:int = 1
var _current_energy_lamp:float = 100
var lamp_on:bool = false

# Les objets
var timerGeneral := Timer.new()
var timerLamp := Timer.new()

# Les signaux
signal CurrentEnergy
signal ConsommatorCount
signal CurrentEnergyLamp

func _ready() -> void:
	timerGeneral.timeout.connect(_on_timer_timeout)
	add_child(timerGeneral)
	timerGeneral.wait_time = 15.5
	timerGeneral.start()

	timerLamp.timeout.connect(_on_timer_Lamp_timeout)
	add_child(timerLamp)
	timerLamp.wait_time = 3.5
	timerLamp.start()

func StartConsommation() -> void:
	_consommator_count = _consommator_count + 1
	ConsommatorCount.emit(_consommator_count)

func StopConsommation() -> void:
	if(_consommator_count <= 1):
		return
	_consommator_count = _consommator_count - 1
	ConsommatorCount.emit(_consommator_count)

func _on_timer_timeout():
	if(_current_energy <= 0):
		return
	_current_energy = _current_energy - _consommator_count
	if(_current_energy <= 0):
		_current_energy = 0
	CurrentEnergy.emit(_current_energy)

func LampOn() -> void:
	lamp_on = true

func LampOff() -> void:
	lamp_on = false

func _on_timer_Lamp_timeout():
	if lamp_on == true:
		if(_current_energy_lamp <= 0):
			return
		_current_energy_lamp = _current_energy_lamp - 3.5
		if(_current_energy_lamp <= 0):
			_current_energy_lamp = 0
		CurrentEnergyLamp.emit(_current_energy_lamp)

func Reset():
	_current_energy = 100
	_current_energy_lamp = 100
	_consommator_count = 1
	CurrentEnergy.emit(_current_energy)
	CurrentEnergyLamp.emit(_current_energy_lamp)
	ConsommatorCount.emit(_consommator_count)
