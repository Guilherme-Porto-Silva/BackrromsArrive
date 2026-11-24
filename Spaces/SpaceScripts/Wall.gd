extends StaticBody2D

var player: CharacterBody2D



func _ready() -> void:

	pass # Replace with function body.



func _process(delta: float) -> void:
	
	if player != null:
		
		if player.global_position.y < (global_position.y + 100):
			
			z_index = 2
			
		else:
			
			z_index = 0



func _on_wall_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body
