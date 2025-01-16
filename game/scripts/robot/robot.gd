extends VehicleBody3D

class_name Robot

@export var behaviour: RobotBehaviour = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var front_left_wheel: VehicleWheel3D = $Wheel_FL
@onready var front_right_wheel: VehicleWheel3D = $Wheel_FR
@onready var rear_left_wheel: VehicleWheel3D = $Wheel_BL
@onready var rear_right_wheel: VehicleWheel3D = $Wheel_BR
@onready var wheels = [front_left_wheel, front_right_wheel, rear_left_wheel, rear_right_wheel]
@onready var ik_target: Node3D = $IK_Target
@onready var ik: SkeletonIK3D = $Skeleton3D/SkeletonIK3D

func _ready():
	if behaviour == null:
		print("No behavior assigned to robot!")
		return
		
	behaviour.init(self)

func _process(delta):
	if behaviour:
		behaviour.execute(self, delta)
