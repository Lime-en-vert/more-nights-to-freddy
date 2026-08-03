extends Node

var poster_active:bool = false
var ai_level := 20
var scare_timer := Timer.new()
signal SpawnGoldenFreddy
signal JumpScareGoldenFreddy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scare_timer.timeout.connect(_on_timer_timeout)
	scare_timer.one_shot = true
	add_child(scare_timer)
	scare_timer.wait_time = 5.5

func SetAI(level:int):
	ai_level = level

func AddAI(amount:int):
	ai_level += amount

func Reset():
	scare_timer.stop()
	poster_active = false

func CameraActive(camera_id: int):
	if(camera_id!=22 && camera_id!=23):
		return
	if poster_active:
		return
	if ai_level <= 0:
		return
	var spawn_chance = ai_level * 3.5
	if randf() * 100 <= spawn_chance:
		_spawn_event(camera_id)

func MasqueActif(actif:bool) -> void:
	if !actif:
		return
	if !poster_active:
		return
	poster_active = false
	scare_timer.stop()
	SpawnGoldenFreddy.emit(0)

func _spawn_event(camera_id):
	var posters = []
	if camera_id == 22:
		posters = [1, 2]
	elif camera_id == 23:
		posters = [3, 4, 5]
	var poster = posters.pick_random()
	SpawnGoldenFreddy.emit(poster)
	poster_active = true
	scare_timer.start()

func _on_timer_timeout():
	poster_active = false
	JumpScareGoldenFreddy.emit()
