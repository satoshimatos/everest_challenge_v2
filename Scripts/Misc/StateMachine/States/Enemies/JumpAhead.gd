extends State

class_name JumpAhead

@export var enemy: CharacterBody2D
@export var over_jump_force: float = -240
@export var over_jump_distance: float = 30

func enter():
	enemy.can_move = false
	if !enemy or !player:
		return
	var anim_player = enemy.get_node("AnimationPlayer")
	enemy.velocity.y = over_jump_force
	if anim_player.has_animation("jump"):
		anim_player.play("jump")

	#enemy.set_collision_mask_value(10, false)  # Disable collision during jump

	# ✅ Properly wait until the enemy lands
	await get_tree().process_frame
	while not enemy.is_on_floor():
		await get_tree().process_frame  # Wait for landing

	#enemy.set_collision_mask_value(10, true)  # Re-enable collision

	Transitioned.emit(self, "chase")  # Now properly transitions

func physics_update(delta: float):
	if not enemy.is_on_floor():
		var direction = sign(enemy.global_position.x - player.global_position.x)
		enemy.velocity.x = over_jump_distance * -direction  # Fix speed issue
		enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

func exit():
	enemy.velocity.x = 0
	enemy.can_move = true
