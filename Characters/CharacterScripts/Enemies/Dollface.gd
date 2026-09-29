extends Enemy

@onready var ray_cast: RayCast2D = $DollfaceRayCast2D

func _ready() -> void:
	
	super._ready()
	
	speed = 150
	
	damage = 5
	
	turn_speed = 150
	
	vision_area = $DollfaceVisionArea
	
	attack_cooldown = 15
	
	timer_ataque = $DollfaceAttackTimer


func saw_player(body) -> void:
	
	if body.is_in_group("players"):
		
		print("Acheio o player!")
		
		player = body# é por isso que player == body quando punch_player e attack_player são chamados
		
		ray_cast.target_position = ray_cast.to_local(player.global_position)
		
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding() and ray_cast.get_collider() == player:
			
			knows_player_position = true


func lost_player(body) -> void:
	
	if body == player:
		
		player = null# para evitar confusões, por exemplo, quando punch_player(body: Node2D) for chamado
			
		knows_player_position = false


func punch_player(body) -> void:
	
	if body == player:# para a função não ser chamada atoa
		
		attack_player()
