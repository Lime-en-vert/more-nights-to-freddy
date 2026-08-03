extends Node

var position = 0
var laportesouvre := false
var porte_open:bool = true
var ai_level := 20
var move_timer := Timer.new()
var run_timer := Timer.new()
var toque_timer := Timer.new()
var running := false
signal ClassicFoxyMove
signal FoxyRunStart
signal FoxyRunEnd
signal Foxyalaporte
signal JumpScareClassicFoxy

func _ready():
	set_process(true)
	add_child(move_timer)
	move_timer.wait_time = 7.5
	move_timer.timeout.connect(_on_timer)
	add_child(run_timer)
	run_timer.wait_time = 1.6
	run_timer.one_shot = true
	run_timer.timeout.connect(_on_run_finished)
	add_child(toque_timer)
	toque_timer.wait_time = 3.35
	toque_timer.one_shot = true
	toque_timer.timeout.connect(_on_toque_finished)

func StartFoxyManager():
	move_timer.start()

func Reset():
	move_timer.stop()
	position = 0

func SetAI(level:int):
	ai_level = level

func AddAI(amount:int):
	ai_level += amount

func _on_timer():
	var chance = randi_range(1,20)
	if chance > ai_level:
		return
	var cam_avant = position
	position += 1
	var cam_apres = position
	ClassicFoxyMove.emit(cam_avant, cam_apres)
	if position == 4:
		StartRun()
		return

func UpdateTimer(is_watched:bool):
	if is_watched:
		move_timer.wait_time = 4.5
	else:
		move_timer.wait_time = 7.5

func StartRun():
	running = true
	move_timer.stop()
	FoxyRunStart.emit()
	run_timer.start()

func _on_run_finished():
	if porte_open:
		JumpScareClassicFoxy.emit()
	else:
		laportesouvre = true
		Foxyalaporte.emit()
		Foxytoque()

func Foxytoque():
	FoxyRunEnd.emit()
	toque_timer.start()

func _on_toque_finished():
	laportesouvre = false
	running = false
	position = 0
	move_timer.start()
	ClassicFoxyMove.emit(3, 0)

func FlashLight():
	if position == 0:
		return
	if position == 4:
		return
	var cam_avant = position
	position -= 1
	ClassicFoxyMove.emit(cam_avant, position)

func PorteOpen(open):
	porte_open = open
	if laportesouvre and porte_open:
		laportesouvre = false
		JumpScareClassicFoxy.emit()
