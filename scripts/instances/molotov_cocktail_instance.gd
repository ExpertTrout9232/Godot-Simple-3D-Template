extends RigidBody3D

@export var throw_force: float = 6.0
@export var fuse_time: float = 0.05

@onready var animation_player: AnimationPlayer = $MolotovCocktail/AnimationPlayer

var exploded: bool

func _ready() -> void:
	exploded = false
	contact_monitor = true
	max_contacts_reported = 1

func _integrate_forces(_state):
	if get_contact_count() > 0 and not exploded:
		exploded = true
		await get_tree().create_timer(fuse_time).timeout
		explode()

func activate(direction: Vector3) -> void:
	linear_velocity = direction.normalized() * throw_force
	var random_axis: Vector3 = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	angular_velocity = global_transform.basis * random_axis * randf_range(2.0, 6.0)

func explode() -> void:
	var particles_scene: Resource = load("res://scenes/particles/explosion_particles.tscn")
	var particles_instance: CPUParticles3D = particles_scene.instantiate()
	get_tree().current_scene.get_node("Level").add_child(particles_instance)
	particles_instance.position = position
	
	queue_free()
