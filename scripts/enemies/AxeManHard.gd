extends ArmoredAxeMan

class_name ArmoredAxeManHard

@onready var obstacle_raycast: RayCast2D = $ObstacleRayCast

func flip_enemy():
	if velocity.x < 0:
		sprite.flip_h = true
		attack_hitbox.position.x = -attack_hitbox_original_position.x
		obstacle_raycast.rotation_degrees = 180
	elif velocity.x > 0:
		sprite.flip_h = false
		attack_hitbox.position.x = attack_hitbox_original_position.x
		obstacle_raycast.rotation_degrees = 0
