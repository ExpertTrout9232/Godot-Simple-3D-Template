extends CharacterBody3D

signal change_tooltip

@export var speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.0011
@export var gravity: float = 9.8

@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/RayCast3D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var peeing_particles: GPUParticles3D = $PeeingParticles

var Ondrova_Proměnná: Vector4 = Vector4(7,6,7,9)

var start_position: Vector3
var start_rotation: Vector3
var start_scale: Vector3
var hand: String
var hand_item_node: Node
var level_node: Node3D

func _ready() -> void:
	start_position = position
	start_rotation = rotation
	start_scale = scale
	hand = ""
	hand_item_node = null
	level_node = get_parent()
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
		
		if target:
			change_tooltip.emit("interact_tooltip", true)
		else:
			change_tooltip.emit("interact_tooltip", false)
		
		if target and Input.is_action_just_pressed("interact"):
			var action: String = target.interact(collider)
			
			if action:
				if action == "item":
					if not hand:
						hand = target.take_item()
						hand_changed()
				elif action == "requirement":
					var required_item: String = target.get_requirement()
					if hand == required_item:
						target.activate()
	else:
		change_tooltip.emit("interact_tooltip", false)
	
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_forwards"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("crouch"):
		scale = Vector3(0.5, 0.5, 0.5)
	else:
		scale = start_scale
	
	if Input.is_action_just_pressed("use_item"):
		if hand and hand_item_node.has_method("use"):
			hand_item_node.use()
	if Input.is_action_just_pressed("secondary_use_item"):
		if hand and hand_item_node.has_method("secondary_use"):
			hand_item_node.secondary_use()
	if Input.is_action_just_pressed("drop_item"):
		if hand:
			hand_item_node.queue_free()
			
			var item_scene: Resource = load("res://scenes/%s.tscn" % hand)
			var item_instance: Node = item_scene.instantiate()
			level_node.add_child(item_instance)
			item_instance.position = Vector3(position.x, position.y - 1.0, position.z)
			
			hand = ""
	
	if Input.is_action_pressed("pee"):
		peeing_particles.emitting = true
	else:
		peeing_particles.emitting = false
	
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

func hand_changed() -> void:
	var item_scene: Resource = load("res://scenes/items/%s_item.tscn" % hand)
	if item_scene:
		var item_instance: Node = item_scene.instantiate()
		head.add_child(item_instance)
		hand_item_node = item_instance
		
		if hand_item_node.has_signal("play_audio"):
			hand_item_node.play_audio.connect(_on_play_audio)

func _on_play_audio(stream: AudioStream) -> void:
	audio_player.stream = stream
	audio_player.play()
