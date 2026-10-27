extends CharacterBody2D

class_name Player

const SPEED = 300

const full_hp = 100

var current_hp: int

@onready var hp_bar = $"../CanvasLayer/hp_bar"

@onready var hp_bar_background = $"../CanvasLayer/hp_bar_background"

@onready var player_sprite = $PlayerSprite

# A anotação @export diz, para a Godot:

# "Mostre essa variável lá na interface do painel Inspetor, para que eu possa preenchê-la manualmente."

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
	
	print("PLAYER: ", velocity)

	move()
	
	animate()

	move_and_slide()



func chose_sprite() -> void:
	
	player_sprite.texture = load("res://Characters/CharacterImages/Guigui-chan/Guigui-chanSpriteSheet.png")



func _ready() -> void:
	
	current_hp = full_hp
	
	state_machine = animations["parameters/playback"]
	
	chose_sprite();



func heal(heal_amount: int) -> void:
	
	current_hp += heal_amount
	
	if current_hp > full_hp:
		
		current_hp = full_hp



func damage(damage_amount: int) -> void:
	
	current_hp -= damage_amount
	
	if current_hp <= 0:
		
		die()



func die() -> void:
	
	get_tree().change_scene_to_file("C:/Users/Igor/Desktop/backroomsArrive/Spaces/SpaceScenes/Menu/menu.tscn")
	
	Memory.kian_found = false
	
	Memory.mondial_found = false
	
	Memory.powder_found = false
	
	Memory.teacup_found = false
