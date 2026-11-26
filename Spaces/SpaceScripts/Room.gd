extends Node

class_name Room

const ROOM_NAMES: Array = [
	
	[
	"res://Spaces/SpaceScenes/Level0/Rooms/full_no_clipble_front_wall_room.tscn",
	"res://Spaces/SpaceScenes/Level0/Rooms/Level0start.tscn",
	"res://Spaces/SpaceScenes/Level0/Rooms/holed_door_room.tscn"
	]
]



func room_randomizer(level_number: int):
	
	get_tree().change_scene_to_file(ROOM_NAMES[level_number].pick_random())



func enter_door(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		room_randomizer(0)
