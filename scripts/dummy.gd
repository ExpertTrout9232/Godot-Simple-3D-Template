extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hit() -> void:
	animation_player.play("break")
	await animation_player.animation_finished
	
	queue_free()
