extends Control

func play() -> void:
	
	Memory.kian_found = false
	
	Memory.mondial_found = false
	
	Memory.powder_found = false
	
	Memory.teacup_found = false
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Level0/Rooms/Level0start.tscn")



func quit() -> void:
	
	get_tree().quit()



func enter_game_config() -> void:
	
	pass



func show_game_credits() -> void:
	
	pass
