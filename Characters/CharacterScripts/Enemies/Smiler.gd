extends Enemy

func _ready() -> void:
	
	super._ready()
	
	speed = 300
	
	damage = 10
	
	timer_ataque = $SmilerAttackTimer
