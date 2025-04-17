extends State

class_name PlayerFloorAttack

var anim_player: AnimationPlayer

const STAMINA_COST = 15

func enter():
	if not has_enough_stamina():
		call_deferred("emit_deferred_transition", "idle") # Need to wait for a frame before switching states
	else:
		player.current_stamina -= STAMINA_COST
		player.StaminaChanged.emit(player.current_stamina)
		player.can_regen_stamina = false
		AudioManager.play("medium_swing")
		player.player_can_move = false
		anim_player = player.get_node("AnimationPlayer")
		if anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.disconnect(_on_animation_finished)
		anim_player.animation_finished.connect(_on_animation_finished)
		if anim_player.has_animation("attack1"):
			anim_player.play("attack1")
		if player.state_label:
			update_state_label(player.state_label, self.name)

func update(_delta: float) -> void:
	player.velocity.x = 0

func _on_animation_finished(_anim_name: String):
	player.player_can_move = true
	player.can_regen_stamina = true
	Transitioned.emit(self, "idle")

func has_enough_stamina() -> bool:
	if player.current_stamina <= 0:
		return false
	return true

func exit():
	player.can_regen_stamina = true
	player.attack_hitbox_disabler(true)
