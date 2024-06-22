@tool
extends Path3D

@export_range(1, 100) var road_length = 1:
	set(value):
		road_length = value
		make_road()
	get:
		return road_length

@export_range(1, 5) var road_width = 1:
	set(value):
		road_width = value
		make_road()
	get:
		return road_width

@export_range(0, 1) var cell_size = 0.1:
	set(value):
		cell_size = value
		make_road()
	get:
		return cell_size

#@export_range(0, 1) var cell_offset = 0.1:
	#set(value):
		#cell_offset = value
		#make_road()
	#get:
		#return cell_offset

@export_range(0.1, 1) var border_width = 0.1:
	set(value):
		border_width = value
		make_road()
	get:
		return border_width

@export var show_decals_grid : bool:
	set(value):
		show_decals_grid = value
		change_decals_grid_visibility(value)	

@export var cell_scene : PackedScene

var _cells_matrix : Dictionary


func _ready():
	for cell in $CellsContainer.get_children():
		_cells_matrix[(cell as Cell).coords] = cell

func make_road():
	if not is_inside_tree():
		return
	
	var final_length = road_length * cell_size
	var final_width = road_width * cell_size + border_width * 2.0
	
	curve.set_point_position(1, Vector3(final_length, 0, 0))
	
	var points = $Road.polygon
	points[2] = Vector2(final_width, 0.1)
	points[3] = Vector2(final_width, 0.0)
	$Road.polygon = points
	
	points[2] = Vector2(border_width, 0.1)
	points[3] = Vector2(border_width, 0.0)
	$BorderLeft.polygon = points
	
	$BorderRight.position = Vector3(0, $BorderRight.position.y, $Road.position.z + final_width - border_width)
	$BorderRight.polygon = points
	
	
	_set_cells_matrix()
	
	


func change_decals_grid_visibility(visibility_flag : bool):
	for cell in _cells_matrix:
		var current_cell = _cells_matrix[cell] as Cell
		var current_cell_decal = current_cell.grid_decal as Decal
		current_cell_decal.visible = visibility_flag


func _set_cells_matrix():
	for cell in _cells_matrix:
		var current_cell = _cells_matrix[cell] as Cell
		current_cell.queue_free()
	_cells_matrix.clear()
	
	var cell_size_half = cell_size / 2.0
	var x_position : float = $Road.position.x + border_width - cell_size_half
	var y_position : float
	for i in range (0, road_width):
		x_position += cell_size
		y_position = - cell_size_half
		for j in range(0, road_length):
			y_position += cell_size
			var current_cell : Cell = cell_scene.instantiate()
			$CellsContainer.add_child(current_cell, false,  0)
			current_cell.owner = $CellsContainer.owner
			current_cell.position = Vector3(y_position, 0.1, x_position)
			current_cell.scale = Vector3(cell_size, cell_size, cell_size)
			current_cell.name = "Cell_" + str(i) + "_" + str(j)
			_cells_matrix[Vector2(i, j)] = current_cell
			current_cell.coords = Vector2(i, j)
			#call_deferred("_set_cell_coords", current_cell, Vector2(i, j))  # Example assignment
#
#
#func _set_cell_coords(cell, coords):
	#cell.coords = coords
	#print(cell.coords)

