extends Node2D

enum State { GREEN, YELLOW_GREEN, YELLOW, RED_YELLOW, RED }
var state: State = State.GREEN

@onready var light = $Light

func set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.GREEN:        light.color = Color.GREEN
		State.YELLOW_GREEN: light.color = Color(1, 0.8, 0)
		State.YELLOW:       light.color = Color.YELLOW
		State.RED_YELLOW:   light.color = Color.ORANGE
		State.RED:          light.color = Color.RED

func get_ars_limit() -> float:
	match state:
		State.GREEN:        return 80.0
		State.YELLOW_GREEN: return 60.0
		State.YELLOW:       return 40.0
		State.RED_YELLOW:   return 20.0
		State.RED:          return 0.0
	return 80.0
