extends Control

@onready var menu : Control = $Menu
@onready var menu_tabcontainer : TabContainer = $Menu/Panel/MarginContainer/TabContainer
@onready var level_container : Node3D = $Main3D/LevelContainer
@onready var camera: Camera3D = $Main3D/Camera

var current_level : Node3D = null
var in_menu : bool = true

func unload_level():
	if (current_level):
		current_level.queue_free()
		current_level = null

func load_level():
	unload_level()
	var level_scene = preload("res://scenes/layouts/factory_1.tscn")
	
	if (level_scene):
		current_level = level_scene.instantiate()
		level_container.add_child(current_level)
		
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
