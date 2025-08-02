extends Area2D
#@onready var player = $"../Player"
var player : CharacterBody2D = null
var in_arena = false
@onready var timer = $Timer
var state = 1
#signal entered_arena
@onready var node_2d = $lights

func _ready() -> void:
	for node in get_parent().get_children():
		if node.is_in_group("player"):
			player = node
			print("player_found")

func _on_body_entered(body):
	if body == player:
		in_arena = true
		#entered_arena.emit()
func _on_body_exited(body: Node2D) -> void:
	if body == player:
		in_arena = false

func _on_timer_timeout():
	print("timeout")
	#if state == "gl":
	#	state = "rl"
	state = - state
	if state < 0:
		for i in node_2d.get_children():
			i.play("red")
	elif state >0:#== "rl":
		#state = "gl"
		for i in node_2d.get_children():
			i.play("green")
#func _on_entered_arena():
#	state = "gl"
#	timer.start()

func _process(delta):
	if player and in_arena:
		if state < 0 and (player.velocity.x != 0 and player.velocity.y != 0):
			#player.health -= 5
			print("hurt")
		
		#if state == "rl" and player.velocity.length() >= 10:
		#	player.health -= 50
