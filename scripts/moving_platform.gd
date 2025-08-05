# I think in order to make a moving platform, it's intended to use static body

extends RigidBody3D

@export var speed: float = 3.0
@export var distance: float = 5.0
@export var axis: Vector3 = Vector3(1.0, 0.0, 0.0)

var start_position: Vector3
var direction: int = 1
var moved: float = 0.0

func _ready() -> void:
	start_position = global_position
	freeze = true
	sleeping = false
	freeze = false
	axis_lock_linear_y = true
	lock_rotation = true

func _physics_process(delta: float) -> void:
	var move_step: float = speed * delta * direction
	moved += move_step
	
	var velocity: Vector3 = axis.normalized() * speed * direction
	linear_velocity = velocity
	
	if abs(moved) >= distance:
		direction *= -1
		moved = clamp(moved, -distance, distance)
