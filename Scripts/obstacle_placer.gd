class_name ObstaclePlacer
extends Node3D

var object_scenes = [
	preload("res://Scenes/ObstacleObjects/obstacle_object1.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object2.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object3.tscn"),
]

#@export var min_count : int = 2
@export var max_count : int = 10

var max_failed_iters_threshold : int = 100


func place_obstacles(obstacles_matrix : Dictionary, road_width : int, road_length : int):
	var random_width_ind : int
	var random_length_ind : int
	var cur_failed_iters : int = 0
	var cur_placed_count : int = 0
	print (road_width)
	while (cur_placed_count < max_count && cur_failed_iters < max_failed_iters_threshold):
		random_width_ind = randi() % road_width
		random_length_ind = randi() % road_length
		#print(Vector2(random_width_ind, random_length_ind))
		var cur_cell = obstacles_matrix[Vector2(random_width_ind, random_length_ind)] as Cell
		#print("is good? - " + str(cur_cell.is_good_for_placing))
		if (cur_cell.is_good_for_placing):
			var scene_instance = object_scenes[randi() % object_scenes.size()].instantiate()
			scene_instance.position = cur_cell.position
			add_child(scene_instance)
			cur_cell.is_good_for_placing = false
			if (random_length_ind - 1 >= 0):
				(obstacles_matrix[Vector2(random_width_ind, random_length_ind - 1)] as Cell).is_good_for_placing = false
			if (random_length_ind + 1 < road_length):
				(obstacles_matrix[Vector2(random_width_ind, random_length_ind + 1)] as Cell).is_good_for_placing = false
			cur_placed_count += 1
		else:
			cur_failed_iters += 1
		
			
