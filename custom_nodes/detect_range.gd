class_name DetectRange
extends Area2D

@export var col_shape_y: CollisionShape2D
@export var col_shape_x: CollisionShape2D
@export var base_range_size: float
@export var stats: UnitStats:
	set(value):
		stats = value
		collision_layer = 4 * (stats.team + 1)
		collision_mask = 2 - stats.team
		
		var shape := RectangleShape2D.new()
		shape.size = Vector2(UnitNavigation.QUARTER_CELL_SIZE.x, base_range_size * stats.attack_range)
		col_shape_y.shape = shape
		col_shape_x.shape = shape
