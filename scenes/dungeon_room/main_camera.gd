class_name MainCamera
extends Camera2D

@export var move_speed: float = 500.0
@export var smoothing: float = 8.0

var _velocity: Vector2 = Vector2.ZERO

# AI Generated, so verify
func _process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	var target_velocity := input_dir * move_speed
	_velocity = _velocity.lerp(target_velocity, smoothing * delta)

	position += _velocity * delta
