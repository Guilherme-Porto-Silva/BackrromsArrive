extends Node2D

@export var secret_area: Node2D

@export var fade_duration: float = 1.0

var player_inside: bool = false



func _ready() -> void:

	if secret_area:

		secret_area.visible = false

	else:

		push_warning("⚠️ secret_area não configurada em %s" % name)



func reveal_secret() -> void:

	if not secret_area:

		push_warning("⚠️ secret_area é null em %s" % name)

		return
	
	var tween = create_tween()
	
	secret_area.visible = true

	secret_area.modulate.a = 0.0
	
	var area_tween = create_tween()

	area_tween.tween_property(secret_area, "modulate:a", 1.0, fade_duration)



func touch(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		player_inside = true
		
		reveal_secret()



func untouch(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		player_inside = false
