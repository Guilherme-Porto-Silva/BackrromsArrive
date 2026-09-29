extends Enemy

func _ready() -> void:
	
	super._ready()
	
	speed = 250
	
	damage = 20
	
	attack_cooldown = 5
	
	turn_speed = 5
	
	timer_ataque = $HoundAttackTimer
