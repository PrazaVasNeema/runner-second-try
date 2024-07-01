class_name RoadPiece
extends Path3D

@export var road_length : float
@export var road_width : int
@export var road_length_in_cells : int

@onready var cells_container = $CellsContainer
@onready var obstacle_placer : ObstaclePlacer = $ObstaclePlacer

var cells_matrix : Dictionary


func fill_cells_matrix():
	for cell in cells_container.get_children():
		cells_matrix[(cell as Cell).coords] = cell
