extends Area2D

class_name Killzone

func _on_body_entered(body: Node2D) -> void:
	print(body.name + " died")
	if body.has_method("_die"):
		body._die()
