extends RobotBehaviour

class_name RandomRobotBehaviour

@export var max_speed: float = 30.0  # Maximum speed
@export var direction_change_interval: float = 2.0  # Time between direction changes
@export var max_steering_angle: float = 0.5  # Maximum steering angle (turning radius)
@export var steering_interpolation_speed: float = 5.0  # Speed of steering interpolation

var current_speed: float = 0.0
var current_direction: Vector3 = Vector3.ZERO
var time_since_last_change: float = 0.0
var target_steering_value: float = 0.0  # Target steering value (between -1 and 1)
var current_steering_value: float = 0.0  # Current steering value for interpolation

func init(robot: Robot):
	robot.animation_player.play("full_retract")

func execute(robot: Robot, delta: float) -> void:
	# Update direction change timer
	time_since_last_change += delta
	if time_since_last_change >= direction_change_interval:
		time_since_last_change = 0.0
		# Random speed and direction change
		current_speed = randf() * max_speed * (1 if randf() > 0.5 else -1)
		current_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
		
		# Random steering behavior: turn between -1 and 1
		target_steering_value = randf_range(-1.0, 1.0) * max_steering_angle
	
	# Interpolate the steering value
	current_steering_value = lerp(current_steering_value, target_steering_value, steering_interpolation_speed * delta)
	
	# Apply engine force (forward movement)
	robot.engine_force = current_speed  # The force applied to the wheels

	# Apply steering value (turning the vehicle)
	robot.steering = current_steering_value  # Steering control (left-right, between -1 and 1)

	# Apply brake force (if needed)
	if current_speed < 0:  # If the speed is negative (going backward), apply some brake
		robot.brake = 0.5  # Apply 50% brake force
	else:
		robot.brake = 0.0  # No brake force when moving forward
