extends Node2D

func _ready():
	get_node("./Player").intro_finished = false

func _on_audio_stream_player_2d_finished():
	get_node("./Player").intro_finished = true
