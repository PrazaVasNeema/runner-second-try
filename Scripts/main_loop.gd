extends Node3D

@export var obstacle_placer : ObstaclePlacer
@export var road_maker : RoadMaker

@export var road_scene : PackedScene
@export var road_speed : float = 2.0
@export var roads_array : Array

@export var player_scene : PackedScene

var queue = []
var max_queue_size = 10
var min_behind : int = 2
var _front_position : float
var _cur_road_ind : int
var _cur_road_remaining_length : float
var _cur_row_ind : int
var _player : Node3D
var _tween : Tween

@onready var _roads_structure : Node3D = $RoadsStructure
@onready var _input_controller : InputController = %InputController
@onready var _move_cooldown_timer : Timer = $MoveCooldown


# Add an item to the queue if it has not reached its maximum capacity
func add_to_queue(item):
	if len(queue) < max_queue_size:
		queue.push_back(item)

# Removes the front item from the queue and returns whether or not the queue was empty
func finish_queue_front():
	queue[0].queue_free()
	return queue.pop_front()


# Called when the node enters the scene tree for the first time.
func _ready():
	#print (road_maker.road_width)
	#obstacle_placer.place_obstacles(road_maker._cells_matrix, road_maker.road_width, road_maker.road_length)
	init_road()
	_player = player_scene.instantiate() as Node3D
	_player.position = Vector3(0, 0, (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_cur_row_ind))
	add_child(_player)
	_tween = create_tween()


func _physics_process(delta):
	var cur_side_mov_dir = _input_controller.side_movement
	if (cur_side_mov_dir != 0 && _move_cooldown_timer.is_stopped()):
		print(str(cur_side_mov_dir) + str((queue[_cur_road_ind] as RoadPiece).road_width - 1) + " " + str(_cur_row_ind + cur_side_mov_dir))
		_cur_row_ind = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		#var a = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		var new_row_coords = (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_cur_row_ind)
		print("row ind: " + str(_cur_row_ind) + ", row coords: " + str(new_row_coords))
		print("road ind: " + str(_cur_road_ind))
		var tween = create_tween()
		tween.tween_property(_player, "position", Vector3(0, 0, new_row_coords + 0.2 * cur_side_mov_dir), 0.1)
		tween.tween_property(_player, "position", Vector3(0, 0, new_row_coords), 0.05)
		#tween.interpolate_value(_player.position, Vector3(0, 0, new_row_coords - _player.position.z), 0, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
		#_player.position = Vector3(0, 0, new_row_coords)
		_move_cooldown_timer.start()
		


func init_road():
	_front_position = 0.0
	while (queue.size() < max_queue_size):
		var road_instance = road_scene.instantiate() as RoadPiece
		_roads_structure.add_child(road_instance)
		road_instance.fill_cells_matrix()
		road_instance.position = Vector3(_front_position, 0.0, 0.0)
		_front_position += road_instance.road_length
		#print((road_instance.cells_matrix[Vector2(1,1)] as Cell).position)
		(road_instance.obstacle_placer as ObstaclePlacer).place_obstacles(road_instance.cells_matrix, road_instance.road_width, road_instance.road_length_in_cells)
		add_to_queue(road_instance)
		
	_cur_road_ind = 0
	while (_cur_road_ind < min_behind):
		var move_for_length = (queue[_cur_road_ind] as RoadPiece).road_length
		for road : RoadPiece in queue:
			road.position += Vector3(-move_for_length, 0.0, 0.0)
		_front_position += -move_for_length
		_cur_road_ind += 1
	_cur_road_remaining_length = 0.0
	_cur_row_ind = (queue[_cur_road_ind] as RoadPiece).road_width / 2

func do_update_structure():
	finish_queue_front()
	var road_instance = road_scene.instantiate() as RoadPiece
	_roads_structure.add_child(road_instance)
	road_instance.fill_cells_matrix()
	road_instance.position = Vector3(_front_position, 0.0, 0.0)
	_front_position += road_instance.road_length
	#print_debug((road_instance.cells_matrix[Vector2(1,1)] as Cell).position)
	(road_instance.obstacle_placer as ObstaclePlacer).place_obstacles(road_instance.cells_matrix, road_instance.road_width, road_instance.road_length_in_cells)
	add_to_queue(road_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (_cur_road_remaining_length > 0.0):
		var move_for_value = road_speed * delta
		for road : RoadPiece in queue:
			road.position += Vector3(-move_for_value, 0.0, 0.0)
		_cur_road_remaining_length -= move_for_value
		_front_position -= move_for_value
	else:
		do_update_structure()
		_cur_road_remaining_length = (queue[_cur_road_ind] as RoadPiece).road_length + _cur_road_remaining_length
		
