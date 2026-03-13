extends Node2D

const SIGNAL_SPACING = 800
const SIGNAL_OFFSET = 250
const TrafficLightScene = preload("res://traffic_light.tscn")

func _ready() -> void:
	for child in get_children():
		if child.has_method("evaluate_stop"):
			child.position.y = -35
	_spawn_signals()

func _draw() -> void:
	var rail_length = 10000
	draw_line(Vector2(-rail_length, 20), Vector2(rail_length, 20), Color.DARK_GRAY, 6)
	draw_line(Vector2(-rail_length, -20), Vector2(rail_length, -20), Color.DARK_GRAY, 6)
	for i in range(-100, 100):
		var x = i * 100
		draw_line(Vector2(x, -25), Vector2(x, 25), Color(0.4, 0.3, 0.2), 4)

func _spawn_signals() -> void:
	var stations = []
	for child in get_children():
		if child.has_method("evaluate_stop"):
			stations.append(child)
	stations.sort_custom(func(a, b): return a.position.x < b.position.x)
	
	for i in range(stations.size()):
		var station_x = stations[i].position.x
		var end_x: float
		if i + 1 < stations.size():
			end_x = stations[i + 1].position.x
		else:
			end_x = station_x + 3000
		
		var x = station_x + SIGNAL_OFFSET
		while x < end_x:
			_place_signal(x)
			x += SIGNAL_SPACING

func _place_signal(x: float) -> void:
	var s = TrafficLightScene.instantiate()
	s.position = Vector2(x, -50)
	add_child(s)
