extends Node3D

signal play_audio

@export var prime_time: float = 10.0

@onready var raycast: RayCast3D = $RayCast3D
@onready var fire_particles: GPUParticles3D = $Node/FireParticles

var lit: bool

func _ready() -> void:
	lit = false

func use() -> void:
	if lit:
		play_audio.emit(load("res://assets/audio/molotov_throw.mp3"))
		
		var molotov_scene: Resource = load("res://scenes/instances/molotov_cocktail_instance.tscn")
		var molotov_instance: RigidBody3D = molotov_scene.instantiate()
		get_tree().current_scene.get_node("Level").add_child(molotov_instance)
		
		var parent_transform: Transform3D = get_parent_node_3d().global_transform
		var forward: Vector3 = -parent_transform.basis.z
		var rotation_y: float = parent_transform.basis.get_euler().y
		var spawn_position: Vector3 = parent_transform.origin
		molotov_instance.global_transform.origin = spawn_position
		molotov_instance.rotation.y = rotation_y
		
		molotov_instance.activate(forward)
		
		get_parent_node_3d().get_parent_node_3d().hand = ""
		queue_free()

func secondary_use() -> void:
	lit = true
	fire_particles.emitting = true
	
	await get_tree().create_timer(prime_time).timeout
	
	var molotov_scene: Resource = load("res://scenes/instances/molotov_cocktail_instance.tscn")
	var molotov_instance: RigidBody3D = molotov_scene.instantiate()
	get_tree().current_scene.get_node("Level").add_child(molotov_instance)
	molotov_instance.position = global_position
	molotov_instance.activate(Vector3.ZERO)
	molotov_instance.explode()
	
	get_parent_node_3d().get_parent_node_3d().hand = ""
	queue_free()
