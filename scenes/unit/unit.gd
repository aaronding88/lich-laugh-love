@tool
class_name Unit
extends Area2D

@export var stats: UnitStats : set = _set_stats

@onready var body: AnimatedSprite2D = $Visuals/Body
@onready var shadow: AnimatedSprite2D = $Visuals/Body/Shadow
@onready var placeholder: Sprite2D = $Visuals/Placeholder
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

func _set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
		
	if not is_node_ready():
		await ready
		
	placeholder.texture = value.unit_texture

	if value.spritesheet:
		placeholder.region_rect.position = Vector2(0, 0)
		placeholder.region_enabled = true
	else:
		placeholder.region_enabled = false
		

func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
		
	outline_highlighter.highlight()

func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	
	outline_highlighter.clear_highlight()
