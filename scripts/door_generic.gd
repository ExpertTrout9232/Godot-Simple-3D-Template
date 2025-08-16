extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio_files: Dictionary[String, AudioStreamMP3] = {
	"door_open": load("res://assets/audio/door_open.mp3") as AudioStreamMP3,
	"door_close": load("res://assets/audio/door_close.mp3") as AudioStreamMP3
}

var door_state: String

func _ready() -> void:
	door_state = "closed"

func interact(collider: Node) -> String:
	if not animation_player.is_playing():
		if collider.name == "DoorknobFrontArea":
			match door_state:
				"closed":
					animation_player.play("door_open _front")
					play_audio(audio_files.get("door_open"))
					door_state = "open_front"
				"open_front":
					animation_player.play("door_close_front")
					play_audio(audio_files.get("door_close"))
					door_state = "closed"
				"open_back":
					animation_player.play("door_close_back")
					play_audio(audio_files.get("door_close"))
					door_state = "closed"
		elif collider.name == "DoorknobBackArea":
			match door_state:
				"closed":
					animation_player.play("door_open _back")
					play_audio(audio_files.get("door_open"))
					door_state = "open_back"
				"open_front":
					animation_player.play("door_close_front")
					play_audio(audio_files.get("door_close"))
					door_state = "closed"
				"open_back":
					animation_player.play("door_close_back")
					play_audio(audio_files.get("door_close"))
					door_state = "closed"
	return ""

func play_audio(audio_stream: AudioStreamMP3) -> void:
	audio_player.stream = audio_stream
	audio_player.play()
