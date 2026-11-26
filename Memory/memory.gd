extends Node

var player: Player

@export var kian_found: bool

@export var mondial_found: bool

@export var powder_found: bool

@export var teacup_found: bool

@export var player_hp: int



func reset () -> void:
	
	Memory.kian_found = false
	
	Memory.mondial_found = false
	
	Memory.powder_found = false
	
	Memory.teacup_found = false
