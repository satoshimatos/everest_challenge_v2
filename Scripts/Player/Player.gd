extends CharacterBody2D

class_name Player

signal DamageDealt
signal DamageTaken
signal StaminaChanged

@onready var sprite: Sprite2D = $Sprite
@onready var state_label: Label = $StateLabel
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_hitbox_original_position = attack_hitbox.position
@onready var player_stats: Node = get_node("/root/PlayerStats")

@onready var state_machine: StateMachine = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var speed: int = player_stats.stats["move_speed"]
@onready var hp: float = player_stats.stats["hp"]
@onready var stamina: float = player_stats.stats["stamina"]
@onready var stamina_regen: float = player_stats.stats["stamina_regen"]
@onready var defense: float = player_stats.stats["defense"]
@onready var attack: float = player_stats.stats["attack"]
@onready var invulnerability_time: float = player_stats.stats["invulnerability_time"]
@export var jump_velocity: int = -250

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var affected_by_gravity = true
var player_can_move: bool = true
var last_attacker: CharacterBody2D
var is_invulnerable: bool = false
var current_hp: float
var current_stamina: float
var can_regen_stamina: bool = true

func _ready() -> void:
	current_hp = hp
	current_stamina = stamina
	attack_hitbox_disabler(true)

func _physics_process(delta: float) -> void:
	state_label.global_position = self.global_position
	move_player(delta)
	move_and_slide()
	if can_regen_stamina:
		regen_stamina()

func move_player(delta) -> void:
	if affected_by_gravity:
		if not is_on_floor():
			velocity.y += gravity * delta
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and player_can_move:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	flip_player()
	
func flip_player():
	if velocity.x < 0:
		sprite.flip_h = true
		attack_hitbox.position.x = -attack_hitbox_original_position.x
	elif velocity.x > 0:
		sprite.flip_h = false
		attack_hitbox.position.x = attack_hitbox_original_position.x

func _input(event: InputEvent) -> void:
	if is_on_floor():
		if player_can_move:
			if event.is_action_pressed("jump"):
				velocity.y = jump_velocity
	if event.is_action_pressed("ui_cancel"):
		var enemies = get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			enemy._die()

func attack_hitbox_disabler(state: bool):
	attack_hitbox.get_node("CollisionShape2D").call_deferred("set", "disabled", state)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	DamageDealt.emit(body, player_stats.stats["attack"])

func _take_damage(value: float, attacker: CharacterBody2D):
	last_attacker = attacker
	var final_damage = calculate_damage(value)
	current_hp -= final_damage
	DamageTaken.emit(current_hp)
	state_machine.transition_to("takedamage")
	if current_hp <= 0:
		state_machine.transition_to("dead")
	
func calculate_damage(damage_value: float) -> float:
	return damage_value - (damage_value * defense / 100)

func give_invulnerability():
	is_invulnerable = true
	var tween = create_tween()
	tween.set_loops(invulnerability_time * 5)  # Adjust loops based on time (5 blinks per second)

	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.1)  # Transparent
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1)  # Opaque

	await get_tree().create_timer(invulnerability_time).timeout  # Wait for invulnerability duration

	tween.stop()  # Stop blinking
	modulate = Color(1, 1, 1, 1)  # Ensure the player is fully visible again
	is_invulnerable = false

func _die():
	current_hp = 0
	DamageTaken.emit(current_hp)
	state_machine.transition_to("dead")

func regen_stamina():
	if current_stamina != stamina:
		current_stamina += stamina_regen
		current_stamina = clamp(current_stamina, -stamina, stamina)
		StaminaChanged.emit(current_stamina)
