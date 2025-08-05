extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.0011
@export var gravity: float = 9.8

@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/RayCast3D

var start_position: Vector3
var start_rotation: Vector3

func _ready() -> void:
	start_position = position
	start_rotation = rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)

func _physics_process(delta) -> void:
	if raycast.is_colliding():
		var collider: Node = raycast.get_collider()
		var target: Node = find_interactable(collider)
		
		if target and Input.is_action_just_pressed("interact"):
			target.interact(collider)
	
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_forwards"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	
	move_and_slide()

func _process(_delta: float) -> void:
	if position.y <= -10:
		position = start_position
		rotation = start_rotation
		head.rotation = Vector3(0.0, 0.0, 0.0)

func find_interactable(node: Node) -> Node:
	while node != null:
		if node.has_method("interact"):
			return node
		node = node.get_parent()
	return null
