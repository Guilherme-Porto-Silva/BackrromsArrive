class_name PlaybleCharacter

extends CharacterBody2D

const SPEED = 100.0

const full_hp: int = 100

var current_hp: int

@onready var hp_bar = $"../CanvasLayer/hp_bar"

@onready var hp_bar_background = $"../CanvasLayer/hp_bar_background"



func _physics_process(delta: float) -> void:

	var directionX := Input.get_axis("walkLeft", "walkRight")
	
	if directionX:
		
		velocity.x = directionX * SPEED
		
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var directionY := Input.get_axis("walkFront", "walkBack")
	
	if directionY:
		
		velocity.y = directionY * SPEED
		
	else:
		
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()



func _ready() -> void:
	
	current_hp = full_hp



func heal(heal_amount: int) -> void:
	
	current_hp += heal_amount
	
	if current_hp > full_hp:
		
		current_hp = full_hp



func damege(damege_amount: int) -> void:
	
	current_hp -= damege_amount
	
	if current_hp < 0:
		
		current_hp = 0
	
	if current_hp == 0:
		
		die()



func die() -> void:
	
	get_tree().change_scene_to_file("C:/Users/Igor/Desktop/backroomsArrive/Spaces/SpaceScenes/Menu/menu.tscn")
	
	Memory.kian_found = false
	
	Memory.mondial_found = false
	
	Memory.powder_found = false
	
	Memory.teacup_found = false
