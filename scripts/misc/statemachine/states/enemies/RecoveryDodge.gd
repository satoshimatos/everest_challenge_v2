extends State

class_name RecoveryDodge

@export var enemy: CharacterBody2D
@export var dodge_speed: float = 150  # Speed for dodging backward
@export var jump_force: float = -130  # Slight hop upward
@export var dodge_duration: float = 0.3  # How long dodge movement lasts
@export var over_jump_force: float = -220  # Stronger jump to go over player
@export var over_jump_distance: float = 160  # Distance to clear player

var dodging: bool = false

func enter():
	enemy.can_move = false
	if !enemy or !player:
		return
	var anim_player = enemy.get_node("AnimationPlayer")

	enemy.is_invulnerable = true
	dodging = true

	var direction = sign(enemy.global_position.x - player.global_position.x)
	var new_position = enemy.global_position + Vector2(dodge_speed * direction / 2, 0)

	# Check if there is space to dodge backward
	if is_space_available(new_position):
		if randi() % 2 == 0:
			jump_over(direction)
		else:
			jump_back(direction)
	else:
		jump_over(direction)

	if anim_player.has_animation("jump"):
		anim_player.play("jump")
	await anim_player.animation_finished

	while not enemy.is_on_floor():
		await get_tree().process_frame
	dodging = false

	enemy.is_invulnerable = false
	enemy.can_move = true
	Transitioned.emit(self, "chase")

func physics_update(delta: float):
	if dodging:
		if not enemy.is_on_floor():
			enemy.velocity.y += enemy.gravity * delta
		enemy.move_and_slide()
	else:
		enemy.velocity.x = 0

func exit():
	enemy.velocity.x = 0
	enemy.can_move = true

func jump_back(direction: int):
	enemy.velocity.x = dodge_speed * direction
	enemy.velocity.y = jump_force
	
func jump_over(direction: int):
	# Not enough space, jump over the player instead
	direction *= -1  # Reverse direction
	enemy.velocity.x = over_jump_distance * direction
	enemy.velocity.y = over_jump_force

# Function to check if enemy has enough space to dodge backward
func is_space_available(target_position: Vector2) -> bool:
	var space_checker = enemy.get_world_2d().direct_space_state
	var space_query = PhysicsRayQueryParameters2D.create(enemy.global_position, target_position, 0b1)
	var result = space_checker.intersect_ray(space_query)

	return result.is_empty()  # If empty, space is available
