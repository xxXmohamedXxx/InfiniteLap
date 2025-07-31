extends Area2D
@export var damage = 5

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body):
	if body == player:
		body.health -= damage
		print("damage")
	
