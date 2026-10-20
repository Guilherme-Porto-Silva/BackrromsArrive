extends CharacterBody2D

@export var speed = 150

@export var damage = 5

@export var turn_speed = 150

@export var attack_cooldown = 15

var player: Player

var knows_player_position: bool

var ray_cast: RayCast2D

var animated_sprite: AnimatedSprite2D

var vision_area: Area2D

var vision_colision: CollisionPolygon2D

var timer_ataque: Timer



func _ready() -> void:
	
	knows_player_position = false
	
	ray_cast = $DollfaceRayCast2D
	
	animated_sprite = $DollfaceAnimatedSprite
	
	vision_area = $DollfaceVisionArea
	
	timer_ataque = $DollfaceAttackTimer
	
	vision_colision = $DollfaceVisionArea/VisionCollision



func _physics_process(_delta: float) -> void:
	
	ray_cast.position = vision_colision.position
	
	if knows_player_position:
		
		var direction = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		rotate_vision(player.global_position)
		print("Eu sei aonde o jogador está!")
		
	else:
		
		velocity = Vector2.ZERO
	
	manege_rotation()

	move_and_slide()



func desviar() -> void:

	pass



func shoot_ray_cast() -> void:

	ray_cast.target_position = ray_cast.to_local(player.global_position)
	
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		
		knows_player_position = true
	
	else:
		
		desviar()



func see(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		print("PEGUEI A VISÃO!")
		
		player = body
		
		shoot_ray_cast()



func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		print("Perdi a visão...")
		
		knows_player_position = false



func attack_player() -> void:
	
	if timer_ataque.is_stopped():
		
		player.damage(damage)
		
		timer_ataque.start(attack_cooldown)



func punch_player(body: Node2D) -> void:
	
	if body == player:
		
		attack_player()



func rotate_vision(player_position: Vector2) -> void:
	
	vision_area.rotation = (player_position - global_position).angle()



func change_animation(animation: String) -> void:
	
	animated_sprite.play(animation)



func manege_rotation() -> void:
	
	var state: String = "walking" if knows_player_position else "idle"

	if vision_area.rotation_degrees >= -45 and vision_area.rotation_degrees < 45:
		
		change_animation(state + "_right")
		
	elif vision_area.rotation_degrees <= -45 and vision_area.rotation_degrees > -135:
		
		change_animation(state + "_up")
		
	elif vision_area.rotation_degrees >= 45 and vision_area.rotation_degrees <= 135:
		
		change_animation(state + "_down")
		
	else:
		
		change_animation(state + "_left")
