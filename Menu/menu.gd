extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var engine: AudioStreamPlayer2D = $Engine

@onready var fade: AnimationPlayer = $CanvasLayer/Fade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_up() -> void:
	fade.play_backwards("Fade out")
	engine.play()
	audio_stream_player.volume_db = lerp(audio_stream_player.volume_db, -80.0, 1)
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Playground/Playground.tscn")


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()
