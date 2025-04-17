extends State

class_name PlayerFreefall

var anim_player: AnimationPlayer

func enter():
	anim_player = player.get_node("AnimationPlayer")
	
	if anim_player.has_animation("freefall"):
		anim_player.play("freefall")
	if player.state_label:
		update_state_label(player.state_label, self.name)

func update(_delta: float) -> void:
	if player.is_on_floor():
		Transitioned.emit(self, "idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		Transitioned.emit(self, "aerialattack")
