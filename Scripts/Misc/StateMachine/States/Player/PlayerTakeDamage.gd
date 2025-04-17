extends State

class_name PlayerTakeDamage

var anim_player: AnimationPlayer

const KNOCKBACK_FORCE = 100.0  # Adjusted for physics movement
const KNOCKBACK_DURATION = 0.3
var knockback_timer: float = 0.0
var knockback_direction: int = 0

func enter():
	if player.current_hp > 0:
		player.give_invulnerability()
	AudioManager.play("player_hit1")
	knockback_timer = KNOCKBACK_DURATION  # Start knockback duration

	var attacker_position = player.last_attacker.global_position
	knockback_direction = -1 if attacker_position.x > player.global_position.x else 1

	player.velocity = Vector2(KNOCKBACK_FORCE * knockback_direction, -KNOCKBACK_FORCE / 2)

	anim_player = player.get_node("AnimationPlayer")
	if anim_player.has_animation("damage"):
		anim_player.play("damage")

func physics_update(delta: float):
	if knockback_timer > 0:
		knockback_timer -= delta
		player.velocity.x = KNOCKBACK_FORCE * knockback_direction
		player.move_and_slide()
	else:
		Transitioned.emit(self, "idle")

func exit():
	player.velocity.x = 0  # Stop movement after knockback
