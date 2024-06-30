extends Node3D

@export var obstacle_placer : ObstaclePlacer
@export var road_maker : RoadMaker

# Called when the node enters the scene tree for the first time.
func _ready():
	print (road_maker.road_width)
	obstacle_placer.place_obstacles(road_maker._cells_matrix, road_maker.road_width, road_maker.road_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
