extends CharacterBody2D

class_name Enemy

@export var enemy_name: String
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var sprite: Sprite2D = $Sprite
@onready var state_label: Label = $StateLabel
@onready var state_machine: StateMachine = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_hitbox_original_position: Vector2 = attack_hitbox.position
@onready var enemydb: Node = get_node("/root/EnemyDb")
@onready var hp_bar: TextureProgressBar = $HPBar

@onready var enemy_stats: Dictionary = enemydb.enemies["type"]["regular"][enemy_name]
@onready var hp: int = enemy_stats["hp"]
@onready var attack: float = enemy_stats["attack"]
@onready var defense: float = enemy_stats["defense"]
@onready var attack_speed: float = enemy_stats["attack_speed"]
@onready var speed: float = enemy_stats["base_speed"]
@onready var attack_distance: float = enemy_stats["attack_distance"]
@onready var give_up_distance: float = enemy_stats["give_up_distance"]
@onready var detection_range: float = enemy_stats["detection_range"]
@onready var current_hp: float = hp

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move: bool = true
var is_invulnerable = false
var can_flip: bool = true

func _physics_process(delta: float) -> void:
	if can_move:
		if not is_on_floor():
			velocity.y += gravity * delta
			
		state_label.global_position = self.global_position
		flip_enemy()
		move_and_slide()

func flip_enemy():
	if velocity.x < 0:
		sprite.flip_h = true
		attack_hitbox.position.x = -attack_hitbox_original_position.x
	elif velocity.x > 0:
		sprite.flip_h = false
		attack_hitbox.position.x = attack_hitbox_original_position.x

func set_hp_bar():
	hp_bar.tint_progress = Color.RED
	hp_bar.max_value = hp
	hp_bar.min_value = 0.0
	hp_bar.value = hp

func _take_damage(body: CharacterBody2D, damage: float):
	if body == self:
		if not is_invulnerable:
			var final_damage = calculate_damage(damage)
			current_hp -= final_damage
			hp_bar.value = current_hp

func calculate_damage(damage_value: float) -> float:
	return damage_value - (damage_value * defense / 100)

func _die():
	_take_damage(self, 999999)
	state_machine.transition_to("die")
