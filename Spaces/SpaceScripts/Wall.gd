extends StaticBody2D

var near: bool



func _ready() -> void:
	
	near = false



func _process(delta: float) -> void:
		
	if Memory.player.global_position.y < (global_position.y + 100):
		
		z_index = 2
		
	else:
		
		z_index = 0
	
	if near:
		
		modulate.a = 0.5

	else:
		
		modulate.a = 1



func aproximou() -> void:
	
	near = true



func afastou() -> void:
	
	near = false



func frontways_level0_wall_body_entered(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		aproximou()



func frontways_level0_wall_body_exited(body: Node2D) -> void:

	if body.is_in_group("players"):
	
		afastou()



func moist_left_null_zone_right_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		aproximou()



func moist_left_null_zone_right_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("players"):
	
		afastou()


func null_zone_left__level_0_wall_right_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		aproximou()



func null_zone_left_level_0_wall_right_body_exited(body: Node2D) -> void:

	if body.is_in_group("players"):
	
		afastou()



func null_zone_right_level_0_wall_left_body_entered(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		aproximou()



func null_zone_right_level_0_wall_left_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("players"):
	
		afastou()



func null_zone_left_level_0_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		aproximou()



func moist_left_wall_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		aproximou()



func moist_left_wall_area_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		afastou()



func moist_right_wall_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		aproximou()



func moist_right_wall_area_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("players"):
		
		afastou()
