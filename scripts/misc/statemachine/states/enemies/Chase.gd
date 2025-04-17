extends State

class_name EnemyChase

@export var enemy: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	if (enemy.state_label):
		update_state_label(enemy.state_label, self.name)

func physics_update(_delta: float):
	check_for_obstacle_height()
	var direction = player.global_position.x - enemy.global_position.x
	
	if direction > enemy.attack_distance:
		enemy.velocity.x = enemy.speed * 2
	elif direction < enemy.attack_distance:
		enemy.velocity.x = -enemy.speed * 2
	else:
		enemy.velocity.x = 0
		
	if enemy.velocity.x != 0:
		if enemy.anim_player.has_animation("walking"):
			enemy.anim_player.play("walking")
	if abs(direction) > enemy.give_up_distance:
		call_deferred("emit_deferred_transition", "wander")
	if abs(direction) <= enemy.attack_distance:
		call_deferred("emit_deferred_transition", "attack1")

func check_for_obstacle_height():
	if enemy.has_node("ObstacleRayCast"):
		var raycast = enemy.get_node("ObstacleRayCast") as RayCast2D
		if raycast.is_colliding() and enemy.is_on_floor():
			call_deferred("emit_deferred_transition", "jumpahead")
