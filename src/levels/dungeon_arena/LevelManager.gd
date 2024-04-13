extends Node

# 负责管理整个地图的设定，包括：
# - 生成游戏地图
# - 初始化玩家位置（在地图中间）

@export var map_size: Vector2i = Vector2i(64, 64)
@export var border_size: int = 2

@onready var level_map: TileMap = $"../LevelMap"
@onready var player: Player = $"../LevelMap/Player"


func _ready():
	draw_blank_tiles()
	draw_floor()
	draw_wall()
	spawn_player()


func draw_blank_tiles():
	for x in map_size.x + border_size * 2:
		for y in map_size.y + border_size * 2:
			level_map.set_cell(0, Vector2i(x, y), 0, Vector2i(5, 16))


func draw_floor():
	var cells = []
	for x in map_size.x:
		for y in map_size.y:
			cells.append(Vector2i(x + border_size, y + border_size))
	level_map.set_cells_terrain_connect(1, cells, 0, 1)


func draw_wall():
	var cells = []
	for x in map_size.x:
		cells.append(Vector2i(x + border_size, border_size))
		cells.append(Vector2i(x + border_size, map_size.y + 1))
	for y in map_size.y:
		cells.append(Vector2i(border_size, y + border_size))
		cells.append(Vector2i(map_size.x + 1, y + border_size))
	level_map.set_cells_terrain_connect(2, cells, 0, 2)


func spawn_player():
	# Place player on center of the map
	player.position = Vector2(
		(map_size.x / 2 + border_size) * 16,
		(map_size.y / 2 + border_size) * 16
	)
	player.setup_camera_limit(
		Vector2(0, 0),
		Vector2(
			(map_size.x + border_size * 2) * 16,
			(map_size.y + border_size * 2) * 16
		)
	)
	pass
