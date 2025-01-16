extends Control

@onready var robot_list_container = $MarginContainer/RobotListVBoxContainer
@onready var template = $MarginContainer/RobotListVBoxContainer/RobotItemTemplate

func add_robot(index):
	var new_robot_ui: HBoxContainer = template.duplicate()
	var robot_name = "Robot %d" % index
	
	new_robot_ui.name = robot_name
	new_robot_ui.visible = true
	
	var label: Label = new_robot_ui.get_node("RobotLabel")
	label.text = robot_name
	
	var dropdown: OptionButton = new_robot_ui.get_node("BehaviourDropdown")
	dropdown.connect("item_selected", func(idx): _on_behaviour_dropdown_item_selected(idx, index - 1))
	
	robot_list_container.add_child(new_robot_ui)

func populate_robot_list():
	for child in robot_list_container.get_children():
		if child.name != "RobotItemTemplate":
			child.queue_free()
	
	Global.behaviours = []  # Initialize the behaviours array
	for i in range(Global.selected_robots):
		add_robot(i + 1)
		Global.behaviours.append("Random")

func _ready():
	populate_robot_list()

func _on_menu_robot_number_changed(_robots: int) -> void:
	populate_robot_list()

func _on_behaviour_dropdown_item_selected(index: int, robot_index: int) -> void:
	var dropdown: OptionButton = robot_list_container.get_child(robot_index + 1).get_node("BehaviourDropdown")
	Global.behaviours[robot_index] = dropdown.get_item_text(index)
