extends State

class_name EnemyWander

@export var enemy: CharacterBody2D

var move_direction: int
var wander_time: float

func randomize_wander():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range(1, 2)

func enter():
	randomize_wander()
	if (enemy.state_label):
		update_state_label(enemy.state_label, self.name)

func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	if enemy.velocity.x != 0:
		if enemy.anim_player.has_animation("walking"):
			enemy.anim_player.play("walking")
	else:
		if enemy.anim_player.has_animation("idle"):
			enemy.anim_player.play("idle")

func physics_update(_delta: float):
	if enemy:
		enemy.velocity.x = move_direction * enemy.speed

	var direction = player.global_position - enemy.global_position
	
	if direction.length() < enemy.detection_range:
		AudioManager.play("grunt1")
		call_deferred("emit_deferred_transition", "chase")
