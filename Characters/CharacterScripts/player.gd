extends CharacterBody2D

class_name Player

const SPEED = 300

const full_hp: int = 100

var animated_sprite: AnimatedSprite2D

var hp_bar: ColorRect

var player_sprite: Sprite2D

var direction: String

var incapacitated: bool



func move() -> void:
	
	if incapacitated:
		
		return
	
	var movement: Vector2 = Vector2(Input.get_axis("walkLeft", "walkRight"), Input.get_axis("walkFront", "walkBack"))

	if movement != Vector2.ZERO:
		
		velocity.x = movement.normalized().x * SPEED
		
		velocity.y = movement.normalized().y * SPEED
	
	else:
	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	manege_rotation(movement)



func _physics_process(_delta: float) -> void:

	move()

	move_and_slide()



func chose_sprite() -> void:
	
	player_sprite.texture = load("res://Characters/CharacterImages/Guigui-chan/Guigui-chanSpriteSheet.png")



func _ready() -> void:
	
	incapacitated = false
	
	player_sprite = $PlayerSprite
	
	animated_sprite = $PlayerAnimatedSprite
	
	hp_bar = $HP/Current
	
	Memory.player_hp = Memory.player_hp if Memory.player_hp > 0 else full_hp
	
	update_health_bar()
	
	direction = "down"
	
	z_index = 1
	
	Memory.player = self



func heal(heal_amount: int) -> void:
	
	Memory.player_hp += heal_amount
	
	if Memory.player_hp > full_hp:
		
		Memory.player_hp = full_hp
	
	update_health_bar()



func damage(damage_amount: int) -> void:
	
	Memory.player_hp = Memory.player_hp - damage_amount
	
	if Memory.player_hp <= 0:
		
		die()
		
	else:
		
		update_health_bar()



func die() -> void:
	
	get_tree().change_scene_to_file("res://Spaces/SpaceScenes/Menu/game_over.tscn")
	
	Memory.reset()



func update_health_bar():

	var ratio: float = float(Memory.player_hp) / full_hp

	hp_bar.scale.x = ratio

	if ratio > 0.6:

		hp_bar.color = Color(0,1,0)

	elif ratio > 0.3:

		hp_bar.color = Color(1,1,0)

	else:

		hp_bar.color = Color(1,0,0)



func change_animation(animation: String) -> void:
	
	animated_sprite.play(animation)



func manege_rotation(movement: Vector2) -> void:

	var state: String = "walking" if movement != Vector2.ZERO else "idle"

	if movement.y < 0:

		direction = "up"

	elif movement.y > 0:

		direction = "down"

	elif movement.x > 0:

		direction = "right"

	elif movement.x < 0:

		direction = "left"
	
	change_animation(state + '_' + direction)



func fall() -> void:
	
	incapacitated = true
	
	velocity = velocity * 0.1
	
	change_animation("falling_" + direction)
