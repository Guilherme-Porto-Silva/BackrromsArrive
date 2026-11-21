extends Area2D

func colected(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		Memory.powder_found = true
		
		queue_free()
