extends State

class_name PlayerIdle

var anim_player: AnimationPlayer

func enter():
	player.player_can_move = true
	anim_player = player.get_node("AnimationPlayer")
	if anim_player.has_animation("idle"):
		anim_player.play("idle")
	if player.state_label:
		update_state_label(player.state_label, self.name)

func update(_delta: float) -> void:
	if player.is_on_floor():
		if player.velocity.x != 0:
			Transitioned.emit(self, "walk")
	else:
		Transitioned.emit(self, "freefall")

func _input(event: InputEvent) -> void:
	if player.is_on_floor():
		if event.is_action_pressed("attack"):
			Transitioned.emit(self, "floorattack")
	
