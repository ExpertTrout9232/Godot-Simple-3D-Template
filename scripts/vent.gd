extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var state: String

func _ready() -> void:
	state = "closed"

func interact(collider: Node) -> String:
	if collider.name == "VentCoverArea":
		if state == "closed":
			return "requirement"
	return ""

func get_requirement() -> String:
	return "screwdriver"

func activate() -> void:
	state = "open"
	animation_player.play("open_vent")
