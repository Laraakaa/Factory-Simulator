extends Control

@onready var menu : Control = $Menu
@onready var menu_tabcontainer : TabContainer = $Menu/MenuPanel/MarginContainer/VBoxContainer/TabContainer
@onready var level_container : Node3D = $Main3D/LevelContainer
@onready var camera: Camera3D = $Main3D/Camera
@onready var spawn_offset = Vector3(5, 0, 0)

var in_menu : bool = true

func unload_level():
	if (Global.current_level):
		Global.current_level.queue_free()
		Global.current_level = null
		
	for child in level_container.get_children():
		child.queue_free()

func load_level():
	unload_level()
	var level_scene = preload("res://scenes/layouts/factory_1.tscn")
	
	if (level_scene):
		Global.current_level = level_scene.instantiate()
		level_container.add_child(Global.current_level)

	var meta = Global.current_level.get_node("LevelMeta") as LevelMeta

	var robot_scene = preload("res://scenes/robot.tscn")
	# Access the root node of the scene
	var robot_scene_root = robot_scene.instantiate()
		
	# Deploy Robots
	for i in range(Global.selected_robots):
		# Set the robot's behaviour
		var robot_behaviour_name = Global.behaviours[i]
		var robot_behaviour_script = load("res://scripts/robot/behaviour/" + robot_behaviour_name.to_lower() + "_behaviour.gd")
		robot_scene_root.behaviour = robot_behaviour_script.new()

		var robot = robot_scene_root.duplicate()
		robot.name = "Robot %d" % i
		Global.current_level.add_child(robot)
		var spawn_point = meta.spawn_start
		robot.global_transform.origin = spawn_point.global_transform.origin + spawn_offset * i
		robot.global_transform.basis = spawn_point.global_transform.basis
		
func toggle_menu():
	in_menu = !in_menu
	menu.visible = in_menu

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _unhandled_input(event):
	# Toggle menu when "Esc" is pressed
	if event.is_action_pressed("toggle_menu"):
		toggle_menu()

func _on_tab_clicked(tab: int) -> void:
	var tab_name = menu_tabcontainer.get_tab_title(tab)
	
	if tab_name == "Quit":
		get_tree().quit(0)

func _on_run_level(level_name: String) -> void:
	in_menu = false
	menu.visible = false
	camera.call("set_locked", false)
	load_level()
