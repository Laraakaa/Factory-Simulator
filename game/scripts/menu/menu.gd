extends Control
signal run_level(level_name: String)
signal robot_number_changed(robots: int)

@onready var level_name_label: Label = $MenuPanel/MarginContainer/VBoxContainer/RunHBoxContainer/SelectedLevelName
@onready var level_list: ItemList = $MenuPanel/MarginContainer/VBoxContainer/TabContainer/Run/MarginContainer/RunVBoxContainer/LevelList

@onready var menu_play_button: Button = $MenuPanel/MarginContainer/VBoxContainer/RunHBoxContainer/PlayButton
@onready var robot_number: SpinBox = $MenuPanel/MarginContainer/VBoxContainer/RunHBoxContainer/RobotNumber

var selected_level: int = 0
var selected_level_name = "Select a level from the list above! ..."

func update():
	update_label()
	update_menu()

func update_label():
	level_name_label.text = "Selected level: " + selected_level_name
	
	if not selected_level == -1:
		level_name_label.label_settings.font_color = Color("FFFFFF")
		
func update_menu():
	if not selected_level == -1:
		menu_play_button.disabled = false

func _ready() -> void:
	level_list.select(selected_level)
	selected_level_name = level_list.get_item_text(selected_level)
	update()

func _on_level_list_item_activated(index: int) -> void:
	selected_level = index
	
	selected_level_name = level_list.get_item_text(index)
	update()

func _on_play_button_pressed() -> void:
	emit_signal("run_level", selected_level_name)

func _on_robot_number_value_changed(value: float) -> void:
	Global.selected_robots = value
	emit_signal("robot_number_changed", value)
