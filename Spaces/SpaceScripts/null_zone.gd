extends Node2D

var player: CharacterBody2D


func _ready() -> void:
	
	player = $"res://Characters/CharacterScenes/Player.tscn/Player"


func _process(_delta: float) -> void:
	
	if player != null:
		
		if player.global_position.y < global_position.y:
			
			z_index = 2
			
		else:
			
			z_index = 0
