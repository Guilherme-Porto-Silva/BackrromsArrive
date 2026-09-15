extends Enemy

func _ready() -> void:
	
	speed = 150.0
	
	damage = 5


func saw_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body


func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		player = null


func punch_player(body: Node2D) -> void:
	
	if body == player:
		
		attack_player()
