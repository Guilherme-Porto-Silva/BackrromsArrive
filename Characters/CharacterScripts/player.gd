extends CharacterBody2D

class_name Player

const SPEED = 300

const full_hp: int = 100

var current_hp: int

var hp_bar: ColorRect

@onready var player_sprite = $PlayerSprite

@export var animations: AnimationTree

var state_machine


func move() -> void:
	
	var direction: Vector2 = Vector2(Input.get_axis("walkLeft", "walkRight"), Input.get_axis("walkFront", "walkBack"))

	if direction != Vector2.ZERO:
		
		animations["parameters/WalkingBlendSpace2D/blend_position"] = direction
		
		velocity.x = direction.normalized().x * SPEED
		
		velocity.y = direction.normalized().y * SPEED
		
		return
	
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.y = move_toward(velocity.y, 0, SPEED)



func animate() -> void:

	if velocity.length() > 1:
		
		state_machine.travel("WalkingBlendSpace2D")
		
		return

	state_machine.travel("IdleBlendSpace2D")



func _physics_process(_delta: float) -> void:

	move()
	
	animate()

	move_and_slide()



func chose_sprite() -> void:
	
	player_sprite.texture = load("res://Characters/CharacterImages/Guigui-chan/Guigui-chanSpriteSheet.png")



func _ready() -> void:
	
	current_hp = full_hp
	
	state_machine = animations["parameters/playback"]
	
	hp_bar = $HP/Current



func heal(heal_amount: int) -> void:
	
	current_hp += heal_amount
	
	if current_hp > full_hp:
		
		current_hp = full_hp
	
	update_health_bar()



func damage(damage_amount: int) -> void:
	
	current_hp = current_hp - damage_amount
	
	if current_hp <= 0:
		
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

	var ratio: float = float(current_hp) / full_hp

	hp_bar.scale.x = ratio

	if ratio > 0.6:

		hp_bar.color = Color(0,1,0)

	elif ratio > 0.3:

		hp_bar.color = Color(1,1,0)

	else:

		hp_bar.color = Color(1,0,0)
