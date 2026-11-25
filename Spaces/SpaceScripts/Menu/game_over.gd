extends Node2D

func return_to_menu() -> void:
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Menu/menu.tscn")



func start_again() -> void:
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Level0/Rooms/Level0start.tscn")



func quit() -> void:
	
	get_tree().quit()



func _on_restart_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Level0/Rooms/Level0start.tscn")



func _on_menu_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Menu/menu.tscn")



func _on_quit_button_pressed() -> void:
	
	get_tree().quit()
