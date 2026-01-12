class_name OutlineHighlighter
extends Node

const TRANSPARENT = Color(0, 0, 0, 0)

@export var visuals: CanvasGroup
@export var outline_color: Color
@export_range(1, 10) var outline_thickness: int

func _ready() -> void:
	visuals.material.set_shader_parameter("line_color", TRANSPARENT)
	
func clear_highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 0)
	visuals.material.set_shader_parameter("line_color", TRANSPARENT)
	
func highlight() -> void: 
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)
	visuals.material.set_shader_parameter("line_color", outline_color)
