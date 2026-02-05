class_name AutoAttackState
extends State

signal target_died
signal target_left_range

var actor_unit: BattleUnit
var target: BattleUnit


func _init(new_actor: Node, current_target: BattleUnit) -> void:
	actor = new_actor
	target = current_target
	

func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.detect_range.area_exited.connect(_on_detect_range_exited)
	actor_unit.attack_timer.timeout.connect(_attack)
	_attack()
	_setup_attack_timer()


func exit() -> void:
	actor_unit.attack_timer.wait_time = actor_unit.stats.get_time_between_attacks()
	actor_unit.attack_timer.stop()
	actor_unit.attack_timer.timeout.disconnect(_attack)
	
func _setup_attack_timer() -> void:
	actor_unit.attack_timer.wait_time = actor_unit.stats.get_time_between_attacks()
	actor_unit.attack_timer.start()
	
func _attack() -> void:
	var direction := UnitNavigation.vector_to_face(target.global_position, actor_unit.global_position)
	actor_unit.set_animation("attack", direction)
	
	if actor_unit.stats.is_melee():
		var hitbox := actor_unit.melee_attack.attack(target.global_position) as HitBox
		hitbox.damage = actor_unit.stats.get_attack_damage()
		hitbox.collision_layer = actor_unit.stats.team + 1
		hitbox.collision_mask = 2 - actor_unit.stats.team
		if not actor_unit.animation_tree.animation_finished.is_connected(_on_attack_hit):
			actor_unit.animation_tree.animation_finished.connect(_on_attack_hit.unbind(1), CONNECT_ONE_SHOT)
		#actor_unit.animation_player.animation_finished.connect(_on_attack_hit.unbind(1), CONNECT_ONE_SHOT)
	else:
		print("TODO spawn ranged projectile")
	
func _on_attack_hit() -> void:
	if not target:
		return
	
	actor_unit.stats.fatigue += UnitStats.FATIGUE_PER_ATTACK
	target.stats.fatigue += UnitStats.FATIGUE_PER_ATTACK
	print("Attack hit triggered")
	if target.stats.health <= 0:
		target_died.emit()
		
func _on_detect_range_exited(area: Area2D) -> void:
	if area is BattleUnit and area == target:
		target_left_range.emit()
