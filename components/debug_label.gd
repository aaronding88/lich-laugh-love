class_name DebugLabel
extends Label

@export var play_area: PlayArea

func _process(_delta) -> void:
	text = str(play_area.get_hovered_tile())
	text += " "
	text += str(play_area.get_local_mouse_position())
