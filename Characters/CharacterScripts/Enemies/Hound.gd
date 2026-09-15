extends Enemy



func _ready() -> void:
	
	super._ready()
	
	var speed = 250.0
	
	var damege: int = 20
	
	attack_cooldown = 5



func _physics_process(delta: float) -> void:

	move_and_slide()
