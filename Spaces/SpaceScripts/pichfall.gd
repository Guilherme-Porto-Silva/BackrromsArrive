extends Node



func _ready() -> void:
	
	pass # Replace with function body.



func _process(delta: float) -> void:
	
	pass


func _on_hole_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Menu/fall_game_over.tscn")
	
		Memory.reset()
