extends Enemy

@onready var ray_cast: RayCast2D = $DollfaceRayCast2D

@onready var animated_sprite: AnimatedSprite2D = $DollfaceAnimatedSprite

signal dollface_saw_player(detectado: bool)



func _ready() -> void:
	
	super._ready()
	
	speed = 150
	
	damage = 5
	
	turn_speed = 150
	
	vision_area = $DollfaceVisionArea
	
	attack_cooldown = 15
	
	timer_ataque = $DollfaceAttackTimer



func _physics_process(_delta: float) -> void:
	
	super._physics_process(_delta)
	
	manege_rotation()


func shoot_ray_cast() -> void:
	
	ray_cast.target_position = ray_cast.to_local(player.global_position)
	
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		
		dollface_saw_player.emit(true)



func saw_player(body) -> void:
	
	if body.is_in_group("players"):
		
		player = body# é por isso que player == body quando punch_player e attack_player são chamados
		
		shoot_ray_cast()



func lost_player(body) -> void:
	
	if body == player:
			
		knows_player_position = false



func punch_player(body) -> void:
	
	if body == player:# para a função não ser chamada atoa
		
		attack_player()



func change_animation(animation) -> void:
	
	animated_sprite.animation = animation



func manege_rotation() -> void:
	
	if rotation >= -45 && rotation >= 45:
		
		if knows_player_position:
			
			change_animation("walking_right")
		
		else:
			
			change_animation("idle_right")
	
	elif rotation < -45 && rotation > 135:
		
		if knows_player_position:
			
			change_animation("idle_up")
		
		else:
			
			change_animation("walking_up")
	
	elif rotation >= -135 && rotation >= -245:
		
		if knows_player_position:
			
			change_animation("idle_left")
		
		else:
			
			change_animation("walking_left")
	
	elif rotation > 45 && rotation < 135:
		
		if knows_player_position:
			
			change_animation("idle_down")
		
		else:
			
			change_animation("walking_down")
