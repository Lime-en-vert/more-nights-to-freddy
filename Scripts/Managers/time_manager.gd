extends Node

# Les variables
var _current_hour:int = 12
var _end_hour:int = 6
var _hour_duration:float = 60.0

# Les objets
@onready var hour_timer := Timer.new()

# Les signaux
signal CurrentHour
signal EndNight

func _ready() -> void:
	hour_timer.timeout.connect(_on_hour_timer_timeout)
	add_child(hour_timer)
	hour_timer.wait_time = _hour_duration

func StartTimeManager():
	hour_timer.start()

func _on_hour_timer_timeout():
	if _current_hour == 12:
		_current_hour = 1
	else:
		_current_hour += 1
	CurrentHour.emit(_current_hour)
	if _current_hour == _end_hour:
		hour_timer.stop()
		EndNight.emit()

func Reset():
	_current_hour = 12
	CurrentHour.emit(_current_hour)
