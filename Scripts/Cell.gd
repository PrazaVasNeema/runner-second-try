class_name Cell

extends Node3D


@export var coords : Vector2 = Vector2(0, 0)

@export var grid_decal : Decal:
	get:
		return $GridDecal as Decal

@export var obstacle_object : ObstacleObject

@export var is_good_for_placing : bool = true
