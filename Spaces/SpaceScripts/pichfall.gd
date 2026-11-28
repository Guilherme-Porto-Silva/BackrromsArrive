extends Node

var TREE

const NUMBERS: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]



func _ready() -> void:
	
	TREE = get_tree()



func _process(delta: float) -> void:
	
	pass



func _on_hole_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		body.fall()
		
		await get_tree().create_timer(1).timeout
		
		TREE.change_scene_to_file("res://Spaces/SpaceScenes/Menu/fall_game_over.tscn")
	
		Memory.reset()



func _on_circular_pitchfall_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
	
		var scene: String = "res://Spaces/SpaceScenes/Menu/fall_game_over.tscn" if NUMBERS.pick_random() != 2 else "res://Spaces/SpaceScenes/Menu/end.tscn"
			
		body.fall()
		
		await get_tree().create_timer(3).timeout
			
		TREE.change_scene_to_file(scene)

		Memory.reset()
