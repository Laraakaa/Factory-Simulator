extends Node3D

@export var zoom_speed: float = 2.0
@export var rotation_speed: float = 2.0
@export var pan_speed: float = 30.0
@export var boundaries: AABB = AABB(Vector3(-50, 5, -50), Vector3(100, 8, 100))

var zoom_level: float = 8
var current_zoom: float = 8
var pan_delta: Vector3 = Vector3.ZERO

func _ready():
	update_camera_zoom()

func _process(delta):
	handle_pan(delta)
	smooth_zoom(delta)

# Handle zooming in and out
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:  # Mouse wheel up
			zoom_level -= zoom_speed
			zoom_level = clamp(zoom_level, boundaries.position.y, boundaries.size.y)
			update_camera_zoom()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:  # Mouse wheel down
			zoom_level += zoom_speed
			zoom_level = clamp(zoom_level, boundaries.position.y, boundaries.size.y)
			update_camera_zoom()

func smooth_zoom(delta):
	# Gradually move current_zoom towards zoom_level
	current_zoom = lerp(current_zoom, zoom_level, 5 * delta)
	update_camera_zoom()

func update_camera_zoom():
	# Modify the camera's zoom by adjusting its vertical position (transform.origin.y)
	var new_position = transform.origin
	new_position.y = current_zoom
	transform.origin = new_position

# Handle panning with WASD keys
func handle_pan(delta):
	var movement = Vector3.ZERO
	
	var camera_rotation = transform.basis
	
	var forward_dir = -camera_rotation.z.normalized()
	var right_dir = camera_rotation.x.normalized()

	# Check for WASD input and move relative to camera's orientation
	if Input.is_action_pressed("move_forward"):  # W
		movement += forward_dir * pan_speed * delta
	if Input.is_action_pressed("move_backward"):  # S
		movement -= forward_dir * pan_speed * delta
	if Input.is_action_pressed("move_left"):  # A
		movement -= right_dir * pan_speed * delta
	if Input.is_action_pressed("move_right"):  # D
		movement += right_dir * pan_speed * delta
	if Input.is_action_pressed("rotate_left"):
		transform.basis = transform.basis.rotated(Vector3.UP, -rotation_speed * delta)
	if Input.is_action_pressed("rotate_right"):
		transform.basis = transform.basis.rotated(Vector3.UP, rotation_speed * delta)

	# Apply movement
	pan_delta += movement

	# Clamp the camera's position to boundaries
	pan_delta.x = clamp(pan_delta.x, boundaries.position.x, boundaries.size.x)
	pan_delta.z = clamp(pan_delta.z, boundaries.position.z, boundaries.size.z)
	
	# Update camera's position
	var new_position = transform.origin
	new_position.x = pan_delta.x
	new_position.z = pan_delta.z
	transform.origin = new_position
