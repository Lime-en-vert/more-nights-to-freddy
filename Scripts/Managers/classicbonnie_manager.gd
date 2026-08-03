extends Node

var position = 0
var porte_open:bool = true
var ai_level := 20
var parcours:Array[int] = [1, 5, 6, 8, 13, 20, 22, 99, 7]
var cameras_cassables:Array[int] = [8, 13, 20, 22, 7]
var cameras_cassees:Array[int] = []
var move_timer := Timer.new()
var breakcamera_timer := Timer.new()
signal ClassicBonnieMove
signal JumpScareClassicBonnie
signal CameraCassé

func _ready() -> void:
	move_timer.timeout.connect(_on_timer_timeout)
	add_child(move_timer)
	move_timer.wait_time = 2
	breakcamera_timer.timeout.connect(CasseCaméra)
	add_child(breakcamera_timer)
	breakcamera_timer.wait_time = 9.0 - (ai_level * 0.3)

func SetAI(level:int):
	ai_level = level

func AddAI(amount:int):
	ai_level += amount

func Reset():
	move_timer.stop()
	position = 0

func StartBonnieManager():
	move_timer.start()

func _on_timer_timeout():
	var opportunité = randi_range(1, 20)
	if opportunité > ai_level:
		return
	if parcours.is_empty():
		return
	if parcours[position] == 99:
		if porte_open == true:
			move_timer.stop()
			JumpScareClassicBonnie.emit()
	var sens = randi_range(1, ai_level*5)
	if sens == 1 and position > 0:
		sens = -1
	else:
		sens = 1
	var cam_avant = parcours[position]
	position += sens
	if position >= parcours.size():
		position = 0
	var cam_apres = parcours[position]
	ClassicBonnieMove.emit(cam_avant, cam_apres)
	if cam_apres in cameras_cassables and cam_apres == NightManager.camera_active:
		if breakcamera_timer.is_stopped():
			breakcamera_timer.start()

func CameraActive(num:int):
	if num == 0:
		breakcamera_timer.stop()
		return
	if parcours.is_empty():
		return
	if parcours[position] in cameras_cassables and num == parcours[position]:
		if breakcamera_timer.is_stopped():
			breakcamera_timer.start()
	else:
		breakcamera_timer.stop()

func CasseCaméra():
	breakcamera_timer.stop()
	var numero = parcours[position]
	if NightManager.camera_active != numero:
		return
	if numero not in cameras_cassees:
		cameras_cassees.append(numero)
		CameraCassé.emit()

func PorteOpen(open:bool):
	porte_open = open
