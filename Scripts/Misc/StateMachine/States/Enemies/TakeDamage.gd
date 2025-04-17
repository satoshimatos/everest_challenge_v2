extends State

class_name TakeDamage

@export var enemy: CharacterBody2D
@onready var sprite = enemy.get_node("Sprite")
var anim_player: AnimationPlayer

func update(_delta):
	if enemy.current_hp <= 0:
		call_deferred("emit_deferred_transition", "die")

func enter():
	AudioManager.play("stab_weak")
	enemy.can_move = false
	flash()
	anim_player = enemy.get_node("AnimationPlayer")
	anim_player.stop()
	if anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.disconnect(_on_animation_finished)
	anim_player.animation_finished.connect(_on_animation_finished)
	if anim_player.has_animation("damage"):
		anim_player.play("damage")
	if (enemy.state_label):
		update_state_label(enemy.state_label, self.name)

func exit():
	enemy.velocity.x = 0
	enemy.can_move = true

func physics_update(_delta: float):
	pass

func _on_animation_finished(_anim_name: String) -> void:
	if enemy.current_hp > 0:
		if randi() % 2 == 0:
			call_deferred("emit_deferred_transition", "recoverydodge")
		call_deferred("emit_deferred_transition", "chase")

func flash():
	var tween = create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.2)

func set_shader_blink_intensity(value: float):
	if sprite and sprite.material is ShaderMaterial:
		var exists = sprite.material.get_shader_parameter("blink_intensity") 
		if exists != null:
			sprite.material.set_shader_parameter("blink_intensity", value)
		else:
			print("Warning: Shader does not have 'blink_intensity' parameter!")
	else:
		print("Warning: No ShaderMaterial found on sprite!")
