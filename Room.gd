class_name MapGenerator extends Node2D

# Dimensões do mapa em tiles
@export var map_width: int = 80

@export var map_height: int = 50

# Quantidade de salas tentadas
@export var room_count: int = 15

# Tamanho mínimo e máximo de cada sala
@export var room_min_size: int = 4

@export var room_max_size: int = 10

# Referência ao TileMapLayer (arraste no editor)
@export var tile_map_layer: TileMapLayer

# Identificadores dos tiles no TileSet (ajuste conforme o seu)
const TILE_FLOOR := Vector2i(0, 0)

const TILE_WALL := Vector2i(1, 0)



# Dados do mapa
var grid: Array = []         # Matriz 2D: 0 = vazio, 1 = chão

var rooms: Array[Room] = []  # Lista de salas geradas



class Room:
	
	var x: int
	
	var y: int
	
	var width: int
	
	var height: int



	func _init(p_x: int, p_y: int, p_w: int, p_h: int):
		
		x = p_x
		
		y = p_y
		
		width = p_w
		
		height = p_h



	# Retorna um retângulo para verificar colisões
	func get_rect() -> Rect2i:
		
		return Rect2i(x, y, width, height)



	# Centro da sala, útil para conectar corredores
	func center() -> Vector2i:
		
		return Vector2i(x + width / 2, y + height / 2)



func _ready():
	
	generate()



func generate():
	
	rooms.clear()
	
	grid = []

	# Cria a matriz preenchida com zeros
	for y in range(map_height):
		
		var row: Array = []
		
		for x in range(map_width):
			
			row.append(0)
			
		grid.append(row)

	place_rooms()
	
	connect_rooms()
	
	draw_map()
	
	
	
func place_rooms():
	
	var attempts := 0
	
	var max_attempts := room_count * 10  # evita loop infinito

	while rooms.size() < room_count and attempts < max_attempts:
		
		attempts += 1

		# Tamanho aleatório
		var w := randi_range(room_min_size, room_max_size)
		
		var h := randi_range(room_min_size, room_max_size)

		# Posição aleatória, garantindo que a sala cabe no mapa
		var x := randi_range(1, map_width - w - 2)
		
		var y := randi_range(1, map_height - h - 2)

		var new_room := Room.new(x, y, w, h)

		# Verifica sobreposição com salas existentes
		var overlaps := false
		
		for existing in rooms:
			# inflate(1) deixa 1 tile de espaço entre salas
			if new_room.get_rect().intersects(existing.get_rect().grow(1)):
				
				overlaps = true
				
				break

		if overlaps:
			
			continue

		# Sala válida: adiciona e marca na grade
		rooms.append(new_room)
		
		carve_room(new_room)



func carve_room(room: Room):
	
	for y in range(room.y, room.y + room.height):
		
		for x in range(room.x, room.x + room.width):
			
			grid[y][x] = 1



func create_l_corridor(start: Vector2i, end: Vector2i):
	
	var corner := Vector2i(end.x, start.y)  # Horizontal primeiro, depois, vertical
	
	# Caminho horizontal
	var x_step := 1 if end.x >= start.x else -1
	
	for x in range(start.x, end.x + x_step, x_step):
		
		grid[x][start.y] = 1
		
		carve_wall_around(x, start.y)
	
	# Caminho vertical
	var y_step := 1 if end.y >= start.y else -1
	
	for y in range(start.y, end.y + y_step, y_step):
		
		grid[end.x][y] = 1
		
		carve_wall_around(end.x, y)
	
	corridors.append({
		"start": start,
		"end": end,
		"corner": corner
	})



func carve_wall_around(x: int, y: int):
	
	# Garante que o corredor tenha chão, não parede
	if grid[x][y] == 0:
		
		grid[x][y] = 1



func get_room_center(room: Rect2i) -> Vector2i:
	
	return Vector2i(
		room.position.x + room.size.x / 2,
		room.position.y + room.size.y / 2
	)



func connect_rooms():
	
	if rooms.size() < 2:
		
		return
	
	# Cria uma lista com os centros de todas as salas
	var centers: Array[Vector2i] = []
	
	for room in rooms:
		
		centers.append(get_room_center(room))
	
	# Para cada sala, conectamos com a mais próxima ainda não conectada
	var connected: Array[int] = [0]  # Sala 0 já está "na rede"
	
	var pending: Array[int] = []
	
	for i in range(1, rooms.size()):
		
		pending.append(i)
	
	while pending.size() > 0:
		
		var best_dist := 999999
		
		var best_from := -1
		
		var best_to := -1
		
		# Procura a conexão mais curta entre uma sala conectada e uma pendente
		for from_idx in connected:
			
			for to_idx in pending:
				
				var dist := centers[from_idx].distance_squared_to(centers[to_idx])
				
				if dist < best_dist:
					
					best_dist = dist
					
					best_from = from_idx
					
				best_to = to_idx
		
				if randf() > 0.5:
			create_l_corridor(start, end)      # horizontal -> vertical
		else:
			create_l_corridor_inverted(start, end)  # vertical -> horizontal
		
		# Move a sala para a lista de conectadas
		pending.erase(best_to)
		
		connected.append(best_to)
		



func draw_map():
	
	tile_map_layer.clear()
	
	for x in range(map_width):
		
		for y in range(map_height):
			
			var pos := Vector2i(x, y)
			
			if grid[x][y] == 1:
				
				# É chão
				tile_map_layer.set_cell(pos, 0, Vector2i(0, 0))
				
			elif is_wall(x, y):
				
				# É parede (tile ao redor de chão)
				tile_map_layer.set_cell(pos, 0, Vector2i(1, 0))



func is_wall(x: int, y: int) -> bool:
	
	# Uma célula vazia que toca chão vira parede
	if grid[x][y] != 0:
		
		return false
	
	for dx in range(-1, 2):
		
		for dy in range(-1, 2):
			
			var nx := x + dx
			
			var ny := y + dy
			
			if nx < 0 or nx >= map_width or ny < 0 or ny >= map_height:
				
				continue
				
			if grid[nx][ny] == 1:
				
				return true
				
	return false
