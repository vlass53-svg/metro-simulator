extends Node2D

func _ready() -> void:
	for station in get_children():
		station.position.y = -35

func _draw():
	# Рисуем рельсы — две линии
	var rail_length = 10000
	draw_line(Vector2(-rail_length, 10), Vector2(rail_length, 10), Color.DARK_GRAY, 4)
	draw_line(Vector2(-rail_length, -10), Vector2(rail_length, -10), Color.DARK_GRAY, 4)
	
	# Шпалы
	for i in range(-100, 100):
		var x = i * 100
		draw_line(Vector2(x, -15), Vector2(x, 15), Color(0.4, 0.3, 0.2), 3)
