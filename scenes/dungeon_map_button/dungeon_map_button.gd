class_name DungeonMapButton
extends Button

signal dungeon_map_button_pressed

func _on_pressed() -> void:
	dungeon_map_button_pressed.emit()
