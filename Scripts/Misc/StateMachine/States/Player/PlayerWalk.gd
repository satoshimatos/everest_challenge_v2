extends State

class_name PlayerWalk

var anim_player: AnimationPlayer

func enter():
	anim_player = player.get_node("AnimationPlayer")
	if anim_player.has_animation("walking"):
		anim_player.play("walking")
	update_state_label(player.state_label, self.name)

func update(_delta: float):
	if player.is_on_floor():
		if player.velocity.x == 0:
			Transitioned.emit(self, "idle")
	else:
		Transitioned.emit(self, "freefall")
		
func _input(event: InputEvent) -> void:
	if player.is_on_floor():
		if event.is_action_pressed("attack"):
			player.velocity.x = 0
			Transitioned.emit(self, "floorattack")
