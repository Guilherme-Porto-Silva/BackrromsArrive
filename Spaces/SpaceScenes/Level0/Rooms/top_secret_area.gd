extends Node2D

@export var secret_area: Node2D

@export var fade_duration: float = 1.0

var player_inside: bool



func _ready() -> void:

	if secret_area:

		secret_area.visible = false

	else:

		push_warning("⚠️ secret_area não configurada em %s" % name)
	
	player_inside = false



func toggle_secret() -> void:

	if not secret_area:

		push_warning("⚠️ secret_area é null em %s" % name)

		return
	
	var tween = create_tween()
	
	secret_area.visible = player_inside

	secret_area.modulate.a = 0.0
	
	var area_tween = create_tween()

	area_tween.tween_property(secret_area, "modulate:a", 1.0, fade_duration)



func touch(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		player_inside = true



func untouch(body: Node2D) -> void:

	if body.is_in_group("players"):
		
		player_inside = false



func _physics_process(delta: float) -> void:
	
	toggle_secret()
