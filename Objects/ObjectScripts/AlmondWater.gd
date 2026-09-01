extends Area2D

const almond_water_heal_amount = 10

func colected(body: CharacterBody2D) -> void:
	
	if body.is_in_group("player"):
		
		body.heal(almond_water_heal_amount)
		
		queue_free()
