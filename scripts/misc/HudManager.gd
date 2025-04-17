extends CanvasLayer

@onready var hp_bar: TextureProgressBar = $HP/HpBar
@onready var stamina_bar: TextureProgressBar = $Stamina/StaminaBar
@onready var delayed_hp_bar: TextureProgressBar = $HP/DelayedHpBar
@onready var delayed_stamina_bar: TextureProgressBar = $Stamina/DelayedStaminaBar
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.connect("DamageTaken", update_hp_bar)
	player.connect("StaminaChanged", update_stamina_bar)
	set_hp_bar()
	set_stamina_bar()

func set_hp_bar():
	hp_bar.max_value = player.hp
	hp_bar.min_value = 0.0
	hp_bar.value = player.current_hp
	delayed_hp_bar.max_value = player.hp
	delayed_hp_bar.min_value = 0.0
	delayed_hp_bar.value = player.current_hp

func set_stamina_bar():
	stamina_bar.max_value = player.stamina
	stamina_bar.min_value = 0.0
	stamina_bar.value = player.current_stamina
	delayed_stamina_bar.max_value = player.stamina
	delayed_stamina_bar.min_value = 0.0
	delayed_stamina_bar.value = player.current_stamina

func update_hp_bar(new_value: float):
	hp_bar.value = new_value
	await get_tree().create_timer(0.2).timeout  
	var tween = create_tween()
	tween.tween_property(delayed_hp_bar, "value", new_value, 0.5)
	tween.set_ease(Tween.EASE_OUT)

func update_stamina_bar(new_value: float):
	stamina_bar.value = new_value
	await get_tree().create_timer(0.2).timeout  
	var tween = create_tween()
	tween.tween_property(delayed_stamina_bar, "value", new_value, 0.2)
	tween.set_ease(Tween.EASE_OUT)
