class_name Enemy

extends CharacterBody2D

var speed: int

var damage: int

var attack_cooldown: int

var player: CharacterBody2D

var turn_speed: int

var timer_ataque: Timer

@onready var vision_area: Area2D

var knows_player_position: bool



func shoot_ray_cast() -> void:
	
	pass



func _ready() -> void:
	
	knows_player_position = false
	
	player = $"."
	
	knows_player_position.dollface_saw_player.connect(on_seeing_player)



func on_seeing_player(detectado: bool):
	
	if detectado:
		
		print("Detectei o player!")
		
	else:
		
		print("Não detectei o player...")



func _physics_process(_delta: float) -> void:
	
	#knows_player_position.dollface_saw_player()
	
	if knows_player_position:
		
		var direction = global_position.direction_to(player.position)
		
		velocity = direction * speed
		
		rotate_vision(player.position)
		
		shoot_ray_cast()
		
	else:
		velocity = Vector2.ZERO# ficar parado
	
	move_and_slide()



func attack_player():
	
	if timer_ataque.is_stopped():
		
		if player.has_method("damage"):
			
			player.damage(damage)
			
			timer_ataque.start()



func rotate_vision(player_position: Vector2) -> void:
	
	var target_angle = (player_position - global_position).angle()
	
	rotation = target_angle
