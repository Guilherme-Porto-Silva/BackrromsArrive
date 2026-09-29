extends Enemy

func _ready() -> void:
	
	super._ready()
	
	speed = 200
	
	damage = 15
	
	attack_cooldown = 5
	
	turn_speed = 50
	
	timer_ataque = $SkinSteallerAttackTimer
