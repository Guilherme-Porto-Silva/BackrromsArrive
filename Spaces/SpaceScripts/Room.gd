extends Node

class_name Room

const ROOM_NAMES: Array = [
	
	[
	"res://Spaces/SpaceScenes/Level0/Rooms/full_no_clipble_front_wall_room.tscn",
	"res://Spaces/SpaceScenes/Level0/Rooms/Level0start.tscn"
	]
]

const ROOM_AMOUNTS: Array = [2]



func room_randomizer(level_number: int):
	
	var random_number: int = RandomNumberGenerator.new().randf_range(0, ROOM_AMOUNTS[level_number])
	
	var random_room: String = ROOM_NAMES[level_number][random_number]
	
	get_tree().change_scene_to_file(random_room)



func level_0_starter_room_left_door_listener_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		room_randomizer(0)
