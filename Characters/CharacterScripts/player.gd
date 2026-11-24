extends CharacterBody2D

class_name Player

const SPEED = 300

const full_hp: int = 100

var animated_sprite: AnimatedSprite2D

var hp_bar: ColorRect

var player_sprite: Sprite2D



func move() -> void:
	
	var direction: Vector2 = Vector2(Input.get_axis("walkLeft", "walkRight"), Input.get_axis("walkFront", "walkBack"))

	if direction != Vector2.ZERO:
		
		velocity.x = direction.normalized().x * SPEED
		
		velocity.y = direction.normalized().y * SPEED
	
	else:
	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	manege_rotation(direction)



func _physics_process(_delta: float) -> void:

	move()

	move_and_slide()



func chose_sprite() -> void:
	
	player_sprite.texture = load("res://Characters/CharacterImages/Guigui-chan/Guigui-chanSpriteSheet.png")



func _ready() -> void:
	
	player_sprite = $PlayerSprite
	
	animated_sprite = $PlayerAnimatedSprite
	
	hp_bar = $HP/Current
	
	Memory.player_hp = Memory.player_hp if Memory.player_hp > 0 else full_hp
	
	update_health_bar()



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
	
	Memory.kian_found = false
	
	Memory.mondial_found = false
	
	Memory.powder_found = false
	
	Memory.teacup_found = false



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



func manege_rotation(direction: Vector2) -> void:

	var state: String = "walking" if direction != Vector2.ZERO else "idle"

	if direction.y < 0:

		change_animation(state + "_up")

	elif direction.y > 0:

		change_animation(state + "_down")

	elif direction.x > 0:

		change_animation(state + "_right")

	elif direction.x < 0:

		change_animation(state + "_left")
