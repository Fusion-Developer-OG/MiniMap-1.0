@tool
extends Panel

@export var FOLLOW_OBJECT : NodePath
var PLAYER : Node3D

@export var SIZE: float = 20.0
@export var HEIGHT: float = 30.0
@export var ALLOW_ROTATION: bool = false

var CAMERA : Camera3D
var _viewport_container : SubViewportContainer
var _viewport : SubViewport

func _ready():
	# 1. Base Panel properties
	clip_contents = true
	custom_minimum_size = Vector2(200, 200)

	# 2. Build the Node Tree dynamically
	_viewport_container = SubViewportContainer.new()
	_viewport_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_viewport_container)

	_viewport = SubViewport.new()
	_viewport.transparent_bg = true
	_viewport.handle_input_locally = false
	_viewport.size = Vector2i(200, 200)
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_viewport_container.add_child(_viewport)

	CAMERA = Camera3D.new()
	CAMERA.projection = Camera3D.PROJECTION_ORTHOGONAL
	CAMERA.size = SIZE
	CAMERA.position = Vector3(0, HEIGHT, 0)
	CAMERA.rotation_degrees = Vector3(-90, 0, 0) # Top-down view
	_viewport.add_child(CAMERA)

	# Fetch player if running in the actual game
	if not Engine.is_editor_hint() and not FOLLOW_OBJECT.is_empty():
		PLAYER = get_node_or_null(FOLLOW_OBJECT)

func _physics_process(_delta):
	# Do not run camera tracking logic inside the Godot Editor
	if Engine.is_editor_hint():
		# Sync editor variables to the camera so you can preview size changes
		if CAMERA:
			CAMERA.size = SIZE
			CAMERA.position.y = HEIGHT
		return
		
	# Dynamically fetch player if it wasn't ready on frame 1
	if not PLAYER and not FOLLOW_OBJECT.is_empty():
		PLAYER = get_node_or_null(FOLLOW_OBJECT)
		
	# Track the player
	if PLAYER and CAMERA:
		CAMERA.global_position = Vector3(PLAYER.global_position.x, HEIGHT, PLAYER.global_position.z)
		
		if ALLOW_ROTATION:
			CAMERA.rotation.y = PLAYER.rotation.y
