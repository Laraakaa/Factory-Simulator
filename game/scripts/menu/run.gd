extends Control
signal run_level(level_name: String)

@onready var level_name_label: Label = $RunVBoxContainer/RunHBoxContainer/SelectedLevelName
@onready var level_list: ItemList = $RunVBoxContainer/LevelList

@onready var menu_play_button: Button = $RunVBoxContainer/RunHBoxContainer/PlayButton

var selected_level: int = -1
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
	update()

func _on_level_list_item_activated(index: int) -> void:
	selected_level = index
	
	selected_level_name = level_list.get_item_text(index)
	update()

func _on_play_button_pressed() -> void:
	emit_signal("run_level", selected_level_name)
