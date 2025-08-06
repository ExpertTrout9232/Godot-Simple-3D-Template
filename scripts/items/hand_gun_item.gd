extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var raycast: RayCast3D = $RayCast3D

func use() -> void:
	if not animation_player.is_playing():
		animation_player.play("fire")
		audio_player.play()
		
		if raycast.is_colliding():
			var collider: Node = raycast.get_collider()
			var target: Node = find_hittable(collider)
			
			if target:
				target.hit()

func find_hittable(node: Node) -> Node:
	while node != null:
		if node.has_method("hit"):
			return node
		node = node.get_parent()
	return null
