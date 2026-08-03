extends Node
class_name ClassicChicaManager

var position = 0
var ventil_open:bool = true
var ai_level := 20
var parcours1:Array[int] = [1, 5, 26, 23, 28, 99, 7]
var parcours2:Array[int] = [1, 5, 26, 27, 23, 28, 99, 7]
var parcourshasard
var parcours:Array[int] = []
var move_timer := Timer.new()
var eat_timer := Timer.new()
var stayoffice = false
signal ClassicChicaMove
signal JumpScareClassicChica

func _ready() -> void:
	move_timer.timeout.connect(_on_timer_timeout)
	add_child(move_timer)
	move_timer.wait_time = 4
	parcourshasard = [parcours2, parcours2]
	eat_timer.timeout.connect(_on_timer_eat_timeout)
	add_child(eat_timer)
	eat_timer.wait_time = 80
	eat_timer.paused = true

func SetAI(level:int):
	ai_level = level

func AddAI(amount:int):
	ai_level += amount

func Reset():
	move_timer.stop()
	position = 0
	await get_tree().create_timer(0.5).timeout
	parcours = []

func StartChicaManager():
	move_timer.start()

func _on_timer_timeout():
	var opportunité = randi_range(1, 20)
	if opportunité > ai_level:
		return
	if parcours.is_empty():
		parcours = parcourshasard.pick_random().duplicate()
	if parcours.is_empty():
		return
	if parcours[position] == 99:
		if ventil_open == true:
			move_timer.stop()
			JumpScareClassicChica.emit()
		if stayoffice == true:
			return
	var sens = randi_range(1, ai_level*5)
	if sens == 1 and position > 0:
		sens = -1
	else:
		sens = 1
	var cam_avant = parcours[position]
	position = position+sens
	var cam_apres
	if position == parcours.size():
		position = 0
		cam_apres = parcours[0]
		parcours = []
	else:
		cam_apres = parcours[position]
	ClassicChicaMove.emit(cam_avant, cam_apres)
	if parcours.size() == 8 and parcours[position] == 27:
		move_timer.stop()
		eat_timer.paused = false

func StartElectrochoc(camera:String):
	if parcours.is_empty():
		return
	if camera == "Camera27" and parcours[position] == 27:
		move_timer.start()
		eat_timer.paused = true
		position = position+1
		ClassicChicaMove.emit(parcours[position-1], parcours[position])

func _on_timer_eat_timeout():
	position = position+1
	eat_timer.stop()
	move_timer.start()
	ClassicChicaMove.emit(parcours[position-1], parcours[position])
	stayoffice = true

func VentilOpen(open:bool):
	ventil_open = open
