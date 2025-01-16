extends Resource

class_name RobotBehaviour

func init(robot: Robot):
	pass

# Called each frame to control the robot.
func execute(robot: Robot, delta: float) -> void:
	# Override this method in derived behaviors
	pass
	
func entered_input(robot: Robot):
	pass
	
func debug_draw(robot: Robot, forward_local: Vector3, local_vector_to_target: Vector3) -> void:
	# Add or get a debug node
	var debug_node = robot.get_node("DebugMesh") as MeshInstance3D
	if debug_node == null:
		debug_node = MeshInstance3D.new()
		debug_node.name = "DebugMesh"
		robot.add_child(debug_node)

	# Create a new immediate mesh for drawing
	var mesh = ImmediateMesh.new()
	
	# Materials
	var red = StandardMaterial3D.new()
	red.albedo_color = Color.RED
	
	var blue = StandardMaterial3D.new()
	blue.albedo_color = Color.BLUE

	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(Vector3(0, 0, 0))
	mesh.surface_add_vertex(forward_local * 2)
	mesh.surface_end()
	mesh.surface_set_material(0, red)
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(Vector3(0, 0, 0))
	mesh.surface_add_vertex(local_vector_to_target)
	mesh.surface_end()
	mesh.surface_set_material(1, blue)

	# Draw direction to target vector (Green)
	#mesh.surface_set_color(Color.GREEN)  # Green color
	#mesh.surface_add_vertex(robot.global_transform.origin)
	#mesh.surface_add_vertex(robot.global_transform.origin + direction_to_target * 2)

	# Draw a line to the target (Blue)
	#mesh.surface_set_color(Color.BLUE)  # Blue color
	#mesh.surface_add_vertex(robot.global_transform.origin)
	#mesh.surface_add_vertex(destination.global_transform.origin)

	# End drawing

	# Assign the mesh to the MeshInstance3D
	debug_node.mesh = mesh

	# Update the mesh to ensure it is rendered correctly
	debug_node.visible = true
