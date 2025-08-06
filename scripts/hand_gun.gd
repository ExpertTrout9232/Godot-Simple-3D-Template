extends Node3D

func interact(_collider: Node) -> String:
	return "item"

func take_item() -> String:
	queue_free()
	return "hand_gun"
