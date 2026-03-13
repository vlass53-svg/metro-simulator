extends Node2D

@export var station_name: String = "Станция"

func _ready():
	var label = get_node_or_null("Station_name")
	if label:
		label.text = station_name

func evaluate_stop(train_x: float) -> String:
	var train_head = train_x + 100
	var marker_x = global_position.x + 130
	var dist = abs(train_head - marker_x)
	
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
