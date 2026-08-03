extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.connect("pressed", nose)
	
func nose():
	$AudioStreamPlayer2D.play()
