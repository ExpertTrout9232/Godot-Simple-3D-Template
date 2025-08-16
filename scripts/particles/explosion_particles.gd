extends CPUParticles3D

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	audio_player.play()
	emitting = true

func _on_audio_player_finished() -> void:
	while emitting:
		await get_tree().process_frame
	queue_free()
