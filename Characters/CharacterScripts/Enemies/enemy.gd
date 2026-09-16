class_name Enemy

extends CharacterBody2D

var speed = 300.0

var damage: int

var player: Node2D

@export var turn_speed: float

@onready var timer_ataque: Timer = $AttackTimer

@onready var vision_area: Area2D

var knows_player_position: bool

func _ready() -> void:
	
	knows_player_position = false

func _physics_process(delta: float) -> void:
	
	if knows_player_position:
		
		var direction = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		rotate_vision(player.global_position, delta)
		
	else:
		velocity = Vector2.ZERO# ficar parado
	
	move_and_slide()

func attack_player():
	
	if timer_ataque.is_stopped():
		
		if player.has_method("damage"):
			
			player.damage(damage)
			
			timer_ataque.start()

func rotate_vision(player_position: Vector2, delta: float) -> void:
	
	var target_angle = (player_position - global_position).angle()
