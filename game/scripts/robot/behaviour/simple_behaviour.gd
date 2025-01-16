extends RobotBehaviour

class_name SimpleRobotBehaviour

enum State {
	NAVIGATE_TO_INPUT,
	DOCK_INPUT,
	GRAB_INPUT,
	NAVIGATE_TO_OUTPUT,
	PUT_OUTPUT,
	END
}

@export var max_speed: float = 10.0  # Maximum speed for navigation
@export var max_steering_angle: float = 0.5  # Maximum steering angle (turning radius)
@export var steering_interpolation_speed: float = 0.5  # Speed of steering interpolation

var current_state: State = State.NAVIGATE_TO_INPUT
var current_speed: float = 0.0
var target_steering_value: float = 0.0
var current_steering_value: float = 0.0

var debug_counter: int = 0  # Counter for debug output
var debug_interval: int = 10  # Print debug info every 10 updates

var max_steering_change: float = 0.1  # Max change per update to prevent overcorrection

var input_1: Node3D = null
var input_2: Node3D = null
var input_handle: Node3D = null

func init(robot: Robot):
	robot.animation_player.play("full_retract")
	input_1 = Global.current_level.find_child("Input_1")
	input_2 = Global.current_level.find_child("Input_2")
	input_handle = Global.current_level.find_child("InputHandle")
	robot.animation_player.connect("animation_finished", _on_animation_finished)

func execute(robot: Robot, delta: float) -> void:
	match current_state:
		State.NAVIGATE_TO_INPUT:
			navigate_to(robot, input_1, delta, State.DOCK_INPUT)
		State.DOCK_INPUT:
			navigate_to(robot, input_2, delta, State.DOCK_INPUT)
		State.GRAB_INPUT:
			grab_input(robot)
		State.NAVIGATE_TO_OUTPUT:
			navigate_to(robot, input_2, delta, State.PUT_OUTPUT)
		State.PUT_OUTPUT:
			put_output(robot)
			
func entered_input(robot: Robot):
	current_state = State.GRAB_INPUT

func navigate_to(robot: Robot, destination: Node3D, delta: float, nextState: State) -> void:
	# Forward vector in local space	
	var local_forward = Vector3(0, 0, 1)
	
	# Calculate the vector to the target in global space
	var target_position = destination.global_transform.origin
	var local_vector_to_target = robot.to_local(target_position)
	var target_distance = local_vector_to_target.length()
	
	var angle_to_target = local_forward.angle_to(local_vector_to_target)
	var cross_product = local_forward.cross(local_vector_to_target).y # left or right?
	
	# Apply force to the wheels for movement
	var wheel_force = 10  # You can adjust this value to control how fast the robot moves
	
	if angle_to_target > 0.1:  # If the angle is large, turn the robot
		var distance_factor = clamp(target_distance / 10.0, 0.1, 1.0)  # Scale factor based on distance
		wheel_force = wheel_force * distance_factor  # Reduce speed as it gets closer
		var steering_value = angle_to_target / deg_to_rad(45)  # Scale steering value
		steering_value = steering_value * distance_factor  # Reduce steering angle as it gets closer
		if cross_product > 0:
			# Turn left (steering value positive)
			robot.front_left_wheel.steering = steering_value
			robot.front_right_wheel.steering = steering_value
			robot.rear_left_wheel.steering = -steering_value
			robot.rear_right_wheel.steering = -steering_value
		else:
			# Turn right (steering value negative)
			robot.front_left_wheel.steering = -steering_value
			robot.front_right_wheel.steering = -steering_value
			robot.rear_left_wheel.steering = steering_value
			robot.rear_right_wheel.steering = steering_value
	else:
		# If the robot is facing the target, move forward
		robot.front_left_wheel.steering = 0
		robot.front_right_wheel.steering = 0
		robot.rear_left_wheel.steering = 0
		robot.rear_right_wheel.steering = 0

	robot.front_left_wheel.engine_force = wheel_force  # Apply force to the left front wheel
	robot.front_right_wheel.engine_force = wheel_force  # Apply force to the right front wheel
	robot.rear_left_wheel.engine_force = wheel_force  # Apply force to the left rear wheel
	robot.rear_right_wheel.engine_force = wheel_force  # Apply force to the right rear wheel

	debug_draw(robot, local_forward, local_vector_to_target)

	if target_distance < 2:
		current_state = nextState

func grab_input(robot: Robot) -> void:
	# Stop robot, apply brakes
	robot.front_left_wheel.engine_force = 0
	robot.front_right_wheel.engine_force = 0
	robot.rear_left_wheel.engine_force = 0
	robot.rear_right_wheel.engine_force = 0
	robot.front_left_wheel.steering = 0
	robot.front_right_wheel.steering = 0
	robot.rear_left_wheel.steering = 0
	robot.rear_right_wheel.steering = 0
	robot.front_left_wheel.brake = 1
	robot.front_right_wheel.steering = 1
	robot.rear_left_wheel.steering = 1
	robot.rear_right_wheel.steering = 1
	
	# robot.animation_player.play("grab_oven")
	robot.ik.target_node = input_handle.get_path()
	robot.animation_player.play("ik_grab")

func put_output(robot: Robot) -> void:
	robot.animation_player.play("put_output")
	current_state = State.NAVIGATE_TO_INPUT

func _on_animation_finished(anim_name):
	if anim_name == "ik_grab":
		# After grabbing the handle, move down the oven door
		Global.current_level.find_child("AnimationPlayer").play("open_oven")
		current_state = State.END
		
