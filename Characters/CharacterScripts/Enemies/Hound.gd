extends CharacterBody2D

@export var speed: float = 250.0

@export var damage: int = 20

@export var turn_speed: float = 5.0

@export var attack_cooldown: float = 5.0

var player: CharacterBody2D = null

var knows_player_position: bool = false

@onready var timer_ataque: Timer = $HoundAttackTimer



func _physics_process(_delta: float) -> void:
	
	if knows_player_position and is_instance_valid(player):
		
		var direction: Vector2 = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		rotate_vision(player.global_position)
	else:
		
		velocity = Vector2.ZERO

	move_and_slide()



func saw_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body as CharacterBody2D
		
		knows_player_position = true



func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		knows_player_position = false



func punch_player(body: Node2D) -> void:
	
	if body == player:
		
		attack_player()



func attack_player() -> void:
	
	if is_instance_valid(player) and timer_ataque.is_stopped():
		
		if player.has_method("damage"):
			
			player.damage(damage)
			
			timer_ataque.start(attack_cooldown)



func rotate_vision(player_position: Vector2) -> void:
	
	rotation = (player_position - global_position).angle()
