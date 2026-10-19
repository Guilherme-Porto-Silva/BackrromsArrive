extends CharacterBody2D

signal dollface_saw_player(detectado: bool)

@export var speed: float = 150.0

@export var damage: int = 5.0

@export var turn_speed: float = 150.0

@export var attack_cooldown: float = 15.0

var player: CharacterBody2D = null

var knows_player_position: bool = false

@onready var ray_cast: RayCast2D = $DollfaceRayCast2D

@onready var animated_sprite: AnimatedSprite2D = $DollfaceAnimatedSprite

@onready var vision_area: Area2D = $DollfaceVisionArea

@onready var timer_ataque: Timer = $DollfaceAttackTimer



func _ready() -> void:
	
	dollface_saw_player.connect(_on_seeing_player)



func _physics_process(_delta: float) -> void:
	
	if knows_player_position and is_instance_valid(player):
		
		var direction: Vector2 = global_position.direction_to(player.global_position)
		
		velocity = direction * speed
		
		rotate_vision(player.global_position)
		
		shoot_ray_cast()
		
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	manege_rotation()



func shoot_ray_cast() -> void:
	
	if not is_instance_valid(player):
		
		return

	ray_cast.target_position = ray_cast.to_local(player.global_position)
	
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		
		dollface_saw_player.emit(true)



func saw_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body as CharacterBody2D
		
		shoot_ray_cast()



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



func change_animation(animation: String) -> void:
	
	if animated_sprite.animation != animation:
		
		animated_sprite.animation = animation



func manege_rotation() -> void:
	
	var deg: float = wrapf(rotation_degrees, -180.0, 180.0)
	
	var state: String = "walking" if knows_player_position else "idle"

	if deg >= -45.0 and deg < 45.0:
		
		change_animation(state + "_right")
		
	elif deg >= 45.0 and deg < 135.0:
		
		change_animation(state + "_down")
		
	elif deg >= -135.0 and deg < -45.0:
		
		change_animation(state + "_up")
		
	else:
		
		change_animation(state + "_left")



func _on_seeing_player(detectado: bool) -> void:
	
	knows_player_position = detectado
	
	if detectado:
		
		print("Detectei o player!")
		
	else:
		
		print("Não detectei o player...")
