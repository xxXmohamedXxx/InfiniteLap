extends Area2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("spikes")

func _collide(body):
	pass
