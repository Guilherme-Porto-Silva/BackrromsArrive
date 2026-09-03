extends Enemy



func _ready() -> void:
	
	var speed = 600.0
	
	var damege: int = 20



func _physics_process(delta: float) -> void:

	move_and_slide()
