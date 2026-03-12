extends Node2D

@export var station_name: String = "Станция"

func _ready():
	var label = get_node_or_null("Station_name")
	if label:
		label.text = station_name
	else:
		print("StationName не найден в ", name)
