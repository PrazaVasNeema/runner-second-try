class_name Cell

extends Node3D

signal player_is_in_cell(cell_coords : Vector2)

@export var coords : Vector2 = Vector2(0, 0)

@export var grid_decal : Decal:
	get:
		return $GridDecal as Decal

@export var obstacle_object : ObstacleObject

@export var is_good_for_placing : bool = true


func _on_area_3d_area_entered(area):
	player_is_in_cell.emit(coords)
