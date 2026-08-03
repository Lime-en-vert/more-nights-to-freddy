extends Node

var position = 0
var camactive = 0
var porte_open:bool = true
var ai_level := 20
var parcours1:Array[int] = [1, 5, 26, 23, 99, 7]
var parcours2:Array[int] = [1, 5, 8, 22, 99, 7]
var parcourshasard
var parcours:Array[int] = []
var move_timer := Timer.new()
signal ClassicFreddyMove
signal JumpScareClassicFreddy

func _ready() -> void:
	move_timer.timeout.connect(_on_timer_timeout)
	add_child(move_timer)
	move_timer.wait_time = 3
	parcourshasard = [parcours1, parcours2]

func SetAI(level:int):
	ai_level = level

func AddAI(amount:int):
	ai_level += amount

func Reset():
	move_timer.stop()
	position = 0
	await get_tree().create_timer(0.5).timeout
	parcours = []

func StartFreddyManager():
	move_timer.start()

func _on_timer_timeout():
	var opportunité = randi_range(1, 20)
	if opportunité > ai_level:
		return
	if parcours.is_empty():
		parcours = parcourshasard.pick_random().duplicate()
	if parcours.is_empty():
		return
	if camactive == parcours[position]:
		return
	if parcours[position] == 99:
		if porte_open == true:
			move_timer.stop()
			JumpScareClassicFreddy.emit()
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
	ClassicFreddyMove.emit(cam_avant, cam_apres)

func CameraActive(camera_id: int):
	camactive = camera_id

func PorteOpen(open:bool):
	porte_open = open
