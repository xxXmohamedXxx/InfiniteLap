extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body):
	if body == player:
		body.oil_affected.emit()

func _on_body_exited(body):
	queue_free()
