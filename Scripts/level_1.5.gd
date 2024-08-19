extends Node2D

func _ready():
	if !vars.played_voice_2:
		$Player/Skeletons.play()