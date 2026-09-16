extends Enemy

@onready var ray_cast: RayCast2D = $DollfaceRayCast2D

func _ready() -> void:
	
	super._ready()
	
	speed = 150.0
	
	damage = 5
	
	turn_speed = 150.0
	
	vision_area = $DollfaceVisionArea


func saw_player(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		player = body
		
		ray_cast.target_position = ray_cast.to_local(player.global_position)
		
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding() and ray_cast.get_collider() == player:
			
			knows_player_position = true


func lost_player(body: Node2D) -> void:
	
	if body == player:
		
		player = null
			
		knows_player_position = false


func punch_player(body: Node2D) -> void:
	
	if body == player:
		
		attack_player()
