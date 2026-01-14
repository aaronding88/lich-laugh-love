class_name BoundingBox
extends TileMapLayer

@onready var walls: TileMapLayer = %Walls

# TODO: Remove this file
func _ready() -> void:
	var used_rect: Rect2i = get_used_rect()
	var top_left     = used_rect.position
	var top_right    = used_rect.position + Vector2i(used_rect.size.x - 1, 0)
	var bottom_left  = used_rect.position + Vector2i(0, used_rect.size.y - 1)
	var bottom_right = used_rect.position + used_rect.size - Vector2i.ONE
	
	print(top_left, top_right, bottom_left, bottom_right)
	print(used_rect.size)
