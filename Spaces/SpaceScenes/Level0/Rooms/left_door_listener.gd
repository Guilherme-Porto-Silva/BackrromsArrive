extends Area2D

const NEXT_SCENE := "res://Spaces/SpaceScenes/Level0/Rooms/full_no_clipble_front_wall_room.tscn"



func _ready() -> void:
	
	pass


func _process(delta: float) -> void:
	
	pass


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		get_tree().change_scene_to_file(NEXT_SCENE)
