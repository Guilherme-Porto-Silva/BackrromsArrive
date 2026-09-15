class_name Enemy

extends CharacterBody2D

var speed = 300.0

var damage: int

var player: Node2D

@onready var timer_ataque: Timer = $AttackTimer

func _physics_process(delta: float) -> void:
	
	if player:
		
		var direction = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		move_and_slide()
		
	else:
		velocity = Vector2.ZERO# ficar parado

func attack_player():
	
	if timer_ataque.is_stopped():
		
		if player.has_method("damage"):
			
			player.damage(damage)
			
			timer_ataque.start()
