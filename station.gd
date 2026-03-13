extends Node2D

@export var station_name: String = "Станция"

func _ready():
	var label = get_node_or_null("Station_name")
	if label:
		label.text = station_name

func show_marker():
	$StopMarker.visible = true

func hide_marker():
	$StopMarker.visible = false

func evaluate_stop(train_x: float) -> String:
	var dist = abs(train_x - global_position.x)
	hide_marker()
	if dist < 10:
		return "Идеально! ⭐"
	elif dist < 30:
		return "Отлично!"
	elif dist < 60:
		return "Хорошо"
	elif dist < 100:
		return "Удовлетворительно"
	else:
		return "Плохо"
