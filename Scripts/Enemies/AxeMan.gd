extends Enemy

class_name ArmoredAxeMan

var direction: Vector2

func _ready() -> void:
	player.DamageDealt.connect(_take_damage)
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	set_hp_bar()
	attack_hitbox_disabler(true)

func flip_enemy():
	if velocity.x < 0:
		sprite.flip_h = true
		attack_hitbox.position.x = -attack_hitbox_original_position.x
	elif velocity.x > 0:
		sprite.flip_h = false
		attack_hitbox.position.x = attack_hitbox_original_position.x

func attack_hitbox_disabler(state: bool):
	attack_hitbox.get_node("CollisionShape2D").call_deferred("set", "disabled", state)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body == player:
		if not player.is_invulnerable:
			player._take_damage(attack, self)
