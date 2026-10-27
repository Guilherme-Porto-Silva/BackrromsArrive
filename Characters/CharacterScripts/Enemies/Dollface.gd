extends CharacterBody2D

var speed = 150

var damage = 5

var attack_cooldown = 15

var player: Player

var seeing_player: bool

var knows_player_position: bool

<<<<<<< HEAD
var near: bool
=======
var seeing_player: bool
>>>>>>> 927c4220799f6dce1a8cb704d7b8b3f772a6eced

var ray_cast: RayCast2D

var animated_sprite: AnimatedSprite2D

var vision_area: Area2D

var vision_colision: CollisionPolygon2D

var timer_ataque: Timer

var colisao: CollisionShape2D



func _ready() -> void:
	
	seeing_player = false
	
	knows_player_position = false
	
	near = true
	
	animated_sprite = $DollfaceAnimatedSprite
	
	vision_area = $DollfaceVisionArea
	
	timer_ataque = $DollfaceAttackTimer
	
	vision_colision = $DollfaceVisionArea/VisionCollision
	
	colisao = $DollfaceFisicalCollision
	
	ray_cast = $DollfaceRayCast2D
	
	ray_cast.add_exception(self)



func _physics_process(_delta: float) -> void:
	
<<<<<<< HEAD
	print("DOLLFACE: ", velocity)
=======
	if seeing_player and not knows_player_position:
		
		shoot_ray_cast()
>>>>>>> 927c4220799f6dce1a8cb704d7b8b3f772a6eced
	
	update_ray_cast()
	
	if knows_player_position and near:
		
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



<<<<<<< HEAD
func update_ray_cast() -> void:
	
	ray_cast.position = to_local(vision_colision.global_position)
=======
func shoot_ray_cast() -> void:

	# O raio sai da ponta do cone de visão (1º vértice do polígono), em coordenadas
	# globais, então, acompanha a rotação do cone.
	ray_cast.global_position = vision_colision.to_global(vision_colision.polygon[0])
	
	# O alvo é o CENTRO do corpo do jogador, e não o global_position dele: a origem
	# do jogador fica nos pés, ~0,5 px abaixo da caixa de colisão. Mirando nos pés,
	# um raio vindo de baixo para cima para antes de encostar na caixa.
	var player_center: Vector2 = player.get_node("CollisionShape2D").global_position
	
	ray_cast.target_position = ray_cast.to_local(player_center)
>>>>>>> 927c4220799f6dce1a8cb704d7b8b3f772a6eced
	
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		
		knows_player_position = true
		
		seeing_player = true
	
	else:
		
		desviar()



func see(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body
		
<<<<<<< HEAD
		ray_cast.target_position = ray_cast.to_local(body.global_position)
=======
		seeing_player = true
		
		shoot_ray_cast()
>>>>>>> 927c4220799f6dce1a8cb704d7b8b3f772a6eced



func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		seeing_player = false
		
		await get_tree().create_timer(2.0).timeout
		
		knows_player_position = seeing_player



func attack_player() -> void:
	
	if timer_ataque.is_stopped():
		
		player.damage(damage)
		
		timer_ataque.start(attack_cooldown)



func punch_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		near = false
		
		player = body
		
		attack_player()



func rotate_vision(player_position: Vector2) -> void:
	
	vision_area.rotation = (player_position - global_position).angle()



func change_animation(animation: String) -> void:
	
	animated_sprite.play(animation)



func manege_rotation() -> void:
	
	if player != null:
		
		if player.global_position.y < global_position.y:
		
			z_index = 2
		
		else:
			
			z_index = 0
	
	var state: String = "walking" if knows_player_position else "idle"
	
<<<<<<< HEAD
	if near:
		
		state = "atacking"

=======
>>>>>>> 927c4220799f6dce1a8cb704d7b8b3f772a6eced
	if vision_area.rotation_degrees >= -45 and vision_area.rotation_degrees < 45:
		
		change_animation(state + "_right")
	
	elif vision_area.rotation_degrees <= -45 and vision_area.rotation_degrees > -135:
		
		change_animation(state + "_up")
	
	elif vision_area.rotation_degrees >= 45 and vision_area.rotation_degrees <= 135:
		
		change_animation(state + "_down")
	
	else:
		
		change_animation(state + "_left")


func afastou(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		near = true
