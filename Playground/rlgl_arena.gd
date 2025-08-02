extends Area2D
#@onready var player = $"../Player"
var player : CharacterBody2D = null
var in_arena = false
@onready var timer = $Timer
var state
signal entered_arena
@onready var node_2d = $Node2D

func _ready() -> void:
	for node in get_parent().get_children():
		if node.is_in_group("player"):
			player = node

func _on_body_entered(body):
	if body == player:
		entered_arena.emit()

func _on_timer_timeout():
	print("timeout")
	if state == "gl":
		state = "rl"
		for i in node_2d.get_children():
			i.play("red")
	elif state == "rl":
		state = "gl"
		for i in node_2d.get_children():
			i.play("green")
func _on_entered_arena():
	state = "gl"
	timer.start()

func _process(delta):
	if player:
		if state == "rl" and player.velocity.length() >= 10:
			player.health -= 50
