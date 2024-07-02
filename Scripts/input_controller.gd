class_name InputController
extends Node

signal jump_pressed

@export var side_movement_deadzone : float = 0.2

var side_movement_raw : float
var side_movement : int :
	get:
		if (abs(side_movement_raw) > 0.2):
			return 1 if side_movement_raw > 0 else -1
		else:
			return 0

func _physics_process(delta):
	side_movement_raw = Input.get_axis("move_left", "move_right")
	
	if (Input.is_action_just_pressed("jump")):
		jump_pressed.emit()
