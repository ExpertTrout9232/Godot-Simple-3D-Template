# AnimationPlayer can play only one animation at a time so it's better to have multiple animation players for each drawer

extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var drawer_state_1: String
var drawer_state_2: String

func _ready() -> void:
	drawer_state_1 = "closed"
	drawer_state_2 = "closed"

func interact(collider: Node) -> String:
	if not animation_player.is_playing():
		if collider.name == "DrawerArea1":
			audio_player.play()
			match drawer_state_1:
				"closed":
					animation_player.play("OpenDrawer1")
					drawer_state_1 = "open"
				"open":
					animation_player.play("CloseDrawer1")
					drawer_state_1 = "closed"
		elif collider.name == "DrawerArea2":
			audio_player.play()
			match drawer_state_2:
				"closed":
					animation_player.play("OpenDrawer2")
					drawer_state_2 = "open"
				"open":
					animation_player.play("CloseDrawer2")
					drawer_state_2 = "closed"
	return ""
