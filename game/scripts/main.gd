extends Control

@onready var menu : Control = $Menu
@onready var level_container : Node3D = $Main3D/LevelContainer

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

func _on_play_pressed() -> void:
	in_menu = false
	menu.visible = false
	load_level()

func _on_quit_pressed() -> void:
	get_tree().quit()
