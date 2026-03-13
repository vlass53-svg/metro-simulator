extends Node2D

func _ready() -> void:
	for station in get_children():
		station.position.y = -35

func _draw():
	var rail_length = 10000
	# Рельсы пошире
	draw_line(Vector2(-rail_length, 20), Vector2(rail_length, 20), Color.DARK_GRAY, 6)
	draw_line(Vector2(-rail_length, -20), Vector2(rail_length, -20), Color.DARK_GRAY, 6)
	# Шпалы
	for i in range(-100, 100):
		var x = i * 100
		draw_line(Vector2(x, -25), Vector2(x, 25), Color(0.4, 0.3, 0.2), 4)
