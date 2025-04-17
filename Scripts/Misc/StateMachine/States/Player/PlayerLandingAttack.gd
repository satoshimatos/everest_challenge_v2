extends State

class_name PlayerLandingAttack

var anim_player: AnimationPlayer

func enter():
	player.player_can_move = false
	anim_player = player.get_node("AnimationPlayer")
	if anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.disconnect(_on_animation_finished)
	anim_player.animation_finished.connect(_on_animation_finished)
	if anim_player.has_animation("landing_attack"):
		anim_player.play("landing_attack")
	if player.state_label:
		update_state_label(player.state_label, self.name)

func _on_animation_finished(_anim_name: String):
	Transitioned.emit(self, "idle")
