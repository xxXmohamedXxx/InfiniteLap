extends Node2D
var lap = 1

func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.velocity.x > 0:
			lap +=1
			print(lap)
			
func _process(delta: float) -> void:
	for node in get_children():
		if node.name == var_to_str(lap):
			node.show()
			for child in node.get_children():
				if child is TileMapLayer:
					child.collision_enabled = true
		elif (node is TileMapLayer) or (node is CharacterBody2D) or (node is Sprite2D) or node.name == "lights":
			pass
		else:
			node.hide()
			for child in node.get_children():
				if child is TileMapLayer:
					child.collision_enabled = false
