extends State

class_name PlayerAerialAttack

var anim_player: AnimationPlayer
var aerial_attack_fall_speed: float = 200

const STAMINA_COST = 18

func enter():
	if not has_enough_stamina():
		call_deferred("emit_deferred_transition", "idle") # need to wait for a frame before switching states
	else:
		player.current_stamina -= STAMINA_COST
		player.StaminaChanged.emit(player.current_stamina)
		player.can_regen_stamina = false
		AudioManager.play("heavy_swing")
		player.can_regen_stamina = false
		player.player_can_move = false
		player.affected_by_gravity = false
		
		anim_player = player.get_node("AnimationPlayer")
		if anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.disconnect(_on_animation_finished)
		anim_player.animation_finished.connect(_on_animation_finished)
		if anim_player.has_animation("attack2"):
			anim_player.play("attack2")
		if player.state_label:
			update_state_label(player.state_label, self.name)

func update(_delta: float) -> void:
	player.velocity.y = aerial_attack_fall_speed

func _on_animation_finished(_anim_name: String):
	player.can_regen_stamina = true
	player.affected_by_gravity = true
	Transitioned.emit(self, "landingattack")

func has_enough_stamina() -> bool:
	if player.current_stamina < 0:
		return false
	return true

func exit():
	player.can_regen_stamina = true
	player.attack_hitbox_disabler(true)
