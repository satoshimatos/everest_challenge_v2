extends State

class_name PlayerDead

var anim_player: AnimationPlayer

func enter():
	player.set_collision_layer_value(10, false)
	player.velocity = Vector2.ZERO  # Stop movement
	player.set_physics_process(false)  # Disable physics updates
	anim_player = player.get_node("AnimationPlayer")
	
	if anim_player.has_animation("death"):
		anim_player.play("death")
	
	player.set_collision_layer_value(1, false)  
	player.set_collision_mask_value(1, false)

	await anim_player.animation_finished

func exit():
	player.set_physics_process(true)  # Re-enable physics if respawning
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
