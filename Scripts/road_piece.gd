class_name RoadPiece
extends Path3D

@export var road_length : float
@export var road_width : int
@export var road_length_in_cells : int
@export var first_row_coords : float
@export var cell_size : float

var cells_matrix : Dictionary

@onready var cells_container = $CellsContainer
@onready var obstacle_placer : ObstaclePlacer = $ObstaclePlacer


func fill_cells_matrix():
	for cell in cells_container.get_children():
		cells_matrix[(cell as Cell).coords] = cell


func get_current_row_coords(row_ind : int) -> float:
	return first_row_coords + cell_size * row_ind
