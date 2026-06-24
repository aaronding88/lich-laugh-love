class_name BattleMapButton
extends Button

signal battle_view_button_pressed
	
func _on_pressed() -> void:
	battle_view_button_pressed.emit()
