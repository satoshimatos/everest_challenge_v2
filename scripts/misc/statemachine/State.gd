extends Node

class_name State

signal Transitioned

var player: CharacterBody2D
var current_entity: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.DamageDealt.connect(_take_damage)

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass

func update_state_label(label: Label, state: String):
	label.text = state

func _input(_event: InputEvent) -> void:
	pass

func _take_damage(body: CharacterBody2D, value: float):
	if owner == body:
		if "is_invulnerable" in body and body.is_invulnerable:
			return  # Skip if the body is invulnerable
		Transitioned.emit(self, "takedamage")

func emit_deferred_transition(state: String):
	Transitioned.emit(self, state)
