extends CharacterBody2D

var speed = 150

var damage = 5

var attack_cooldown = 15

var player: Player

var seeing_player: bool

var knows_player_position: bool

var near: bool

var ray_cast: RayCast2D

var animated_sprite: AnimatedSprite2D

var vision_area: Area2D

var vision_colision: CollisionPolygon2D

var timer_ataque: Timer

var nav_agent: NavigationAgent2D

var acceleration: float = 600.0

var lookahead_distance: float = 10.0

var time_standing_still: int

var last_position: Vector2



func _ready() -> void:
	
	seeing_player = false
	
	knows_player_position = false
	
	near = false

	animated_sprite = $DollfaceAnimatedSprite
	
	vision_area = $DollfaceVisionArea
	
	timer_ataque = $DollfaceAttackTimer
	
	vision_colision = $DollfaceVisionArea/VisionCollision
	
	ray_cast = $DollfaceRayCast2D
	
	ray_cast.add_exception(self)
	
	time_standing_still = 0
	
	
	
	nav_agent = $DollfaceNavigationAgent

	nav_agent.avoidance_enabled = true
	
	nav_agent.max_speed = speed
	
	#nav_agent.radius = 70.0
	
	nav_agent.time_horizon_obstacles = 1.5
	
	nav_agent.path_desired_distance = 8.0
	
	nav_agent.target_desired_distance = 1

	nav_agent.avoidance_layers = 1



func _physics_process(delta: float) -> void:
	
	if seeing_player and not knows_player_position:
		
		shoot_ray_cast()

	update_ray_cast()

	if knows_player_position and player != null:
		
		chase_player(delta)
			
	else:
		
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	manege_rotation()
	
	move_and_slide()
	
	if last_position == position:
		
		time_standing_still += 1
	
	last_position = position
	
	if time_standing_still > 5:
		
		walk_around_corner(time_standing_still)



func get_lookahead_target(path: PackedVector2Array, current_pos: Vector2, distance: float) -> Vector2:
	
	if path.size() == 0:
		
		return current_pos
	
	var closest_index := 0
	
	var closest_dist_sq := current_pos.distance_squared_to(path[0])
	
	for i in range(1, path.size()):
		
		var dist_sq := current_pos.distance_squared_to(path[i])
		
		if dist_sq < closest_dist_sq:
			
			closest_dist_sq = dist_sq
			
			closest_index = i
	
	var target := path[closest_index]
	
	var remaining := distance
	
	for i in range(closest_index, path.size() - 1):
		
		var segment := path[i + 1] - path[i]
		
		var segment_length := segment.length()
		
		if segment_length <= 0.001:
			
			continue
		
		if remaining <= segment_length:
			
			target = path[i] + segment.normalized() * remaining
			
			break
		
		remaining -= segment_length
		
		target = path[i + 1]
	
	return target



func update_ray_cast() -> void:
	
	ray_cast.position = to_local(vision_colision.global_position)



func chase_player(delta) -> void:
	
	nav_agent.target_position = player.global_position

	if nav_agent.is_navigation_finished():
		
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		
	else:
		
		var path: PackedVector2Array = nav_agent.get_current_navigation_path()
		
		var target := get_lookahead_target(path, global_position, lookahead_distance)
		
		var direction := global_position.direction_to(target)
		
		velocity = velocity.move_toward(direction * speed, acceleration * delta)

	rotate_vision(player.global_position)



func shoot_ray_cast() -> void:
	
	ray_cast.global_position = vision_colision.to_global(vision_colision.polygon[0])

	var player_center: Vector2 = player.get_node("CollisionShape2D").global_position
	
	ray_cast.target_position = ray_cast.to_local(player_center)
	
	ray_cast.force_raycast_update()

	if ray_cast.is_colliding() and ray_cast.get_collider() == player:
		
		knows_player_position = true
		
		seeing_player = true



func see(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body
		
		ray_cast.target_position = ray_cast.to_local(body.global_position)
		
		seeing_player = true
		
		shoot_ray_cast()



func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		seeing_player = false
		
		await get_tree().create_timer(25.0).timeout
		
		knows_player_position = seeing_player



func attack_player() -> void:
	
	if timer_ataque.is_stopped():
		
		player.damage(damage)
		
		timer_ataque.start(attack_cooldown)



func punch_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		near = true
		
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

	if near:
		
		state = "atacking"

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
		
		near = false


func walk_around_corner(previous_time_standing_still) -> void:
	
	if knows_player_position and position == last_position:
		
		velocity.y += speed
		
		await get_tree().create_timer(15.0).timeout
	
		if knows_player_position and position == last_position:
			
			velocity.y -= speed
			
			await get_tree().create_timer(15.0).timeout
	
			if knows_player_position and position == last_position:
				
				velocity.x -= speed
				
				await get_tree().create_timer(15.0).timeout
		
				velocity.y += speed
				
				await get_tree().create_timer(15.0).timeout
	
				if knows_player_position and position == last_position:
					
					velocity.x -= speed
					
					await get_tree().create_timer(15.0).timeout
			
					velocity.y -= speed
					
					await get_tree().create_timer(15.0).timeout
		
	else:
		
		time_standing_still = 0
