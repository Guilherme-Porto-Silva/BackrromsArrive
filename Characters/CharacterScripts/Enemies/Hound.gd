extends CharacterBody2D

@export var speed: float = 250.0

@export var damage: int = 20

@export var turn_speed: float = 5.0

@export var attack_cooldown: float = 5.0

var player: CharacterBody2D

var knows_player_position: bool

var timer_ataque: Timer

var ray_cast: RayCast2D

var animated_sprite: AnimatedSprite2D

var vision_area: Area2D



func _ready() -> void:
	
	knows_player_position = false
	
	player = $"res://Characters/CharacterScenes/Player.tscn"
	
	ray_cast = $HoundRayCast2D
	
	animated_sprite = $HoundAnimatedSprite
	
	vision_area = $HoundVisionArea
	
	timer_ataque = $HoundAttackTimer



func _physics_process(_delta: float) -> void:
	
	if knows_player_position:
		
		var direction: Vector2 = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		rotate_vision(player.global_position)
		
	else:
		
		velocity = Vector2.ZERO

	move_and_slide()



func saw_player(body: Node2D) -> void:
	
	knows_player_position = body.is_in_group("players")



func lost_player(body: Node2D) -> void:
	
	knows_player_position = !body.is_in_group("players")



func bite_player(body: Node2D) -> void:
	
	if body == player:
		
		attack_player()



func attack_player() -> void:
	
	if timer_ataque.is_stopped():
		
		player.damage(damage)
		
		timer_ataque.start(attack_cooldown)



func rotate_vision(player_position: Vector2) -> void:
	
	rotation = (player_position - global_position).angle()
