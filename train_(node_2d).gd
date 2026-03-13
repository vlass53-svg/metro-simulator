extends Node2D

# === Физика поезда ===
var speed: float = 0.0          # текущая скорость (км/ч)
var max_speed: float = 80.0     # ограничение АРС
var acceleration: float = 2.5   # разгон на каждый notch
var brake_force: float = 5.0    # служебное торможение
var emergency_brake: float = 15.0  # экстренное

# === Контроллер машиниста ===
var throttle_notch: int = 0     # 0-4 (позиции тяги)
var brake_notch: int = 0        # 0-7 (позиции тормоза)

# === АРС (автоматическое ограничение скорости) ===
var ars_limit: float = 80.0     # текущее ограничение

# === Сигнал ===
enum TrafficSignal { GREEN, YELLOW_GREEN, YELLOW, RED, WHITE }
var current_signal: TrafficSignal = TrafficSignal.GREEN

# === Станция ===
var at_station: bool = false
var doors_open: bool = false
var door_timer: float = 0.0
var door_wait_time: float = 5.0  # секунд стоянки




func _process(delta: float) -> void:
	_update_speed(delta)
	_check_ars()
	_move(delta)
	_check_station()
	_update_hud()


func _update_speed(delta: float) -> void:
	if brake_notch > 0:
		var force = brake_force * brake_notch * delta
		speed = max(0.0, speed - force)
	elif throttle_notch > 0:
		var force = acceleration * throttle_notch * delta
		speed = min(ars_limit, speed + force)
	else:
		# выбег — поезд медленно замедляется сам
		speed = max(0.0, speed - 0.3 * delta)

func _check_ars() -> void:
	# АРС автоматически тормозит при превышении
	if speed > ars_limit + 2.0:
		brake_notch = 7  # автостоп
		print("АРС: автостоп! Превышение скорости!")

func _move(delta: float) -> void:
	# переводим км/ч в пиксели/сек (масштаб: 1 м = 5 пикселей)
	var pixel_speed = (speed / 3.6) * 5.0
	position.x += pixel_speed * delta

func _update_hud() -> void:
	var h = get_node_or_null("HUD")
	if h:
		h.refresh(speed, ars_limit, throttle_notch, brake_notch, current_signal, doors_open)
	else:
		print("HUD не найден!")
		
# === Ввод игрока ===
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throttle_up"):
		if brake_notch > 0:
			brake_notch -= 1
		else:
			throttle_notch = min(4, throttle_notch + 1)
	
	if event.is_action_pressed("throttle_down"):
		if throttle_notch > 0:
			throttle_notch -= 1
		else:
			brake_notch = min(7, brake_notch + 1)
	
	if event.is_action_pressed("neutral"):
		throttle_notch = 0
		brake_notch = 0
	
	if event.is_action_pressed("emergency_brake"):
		throttle_notch = 0
		brake_notch = 7
	
	if event.is_action_pressed("open_doors"):
		if doors_open:
			doors_open = false
		elif at_station and speed < 2.0:
			var track = get_node_or_null("../Track")
			if track:
				for station in track.get_children():
					var dist = abs(position.x - station.global_position.x)
					if dist < 150:
						var result = station.evaluate_stop(position.x)
						var h = get_node_or_null("HUD")
						if h:
							h.show_stop_result(result)
			if doors_open:
				doors_open = false
				var h = get_node_or_null("HUD")
				if h:
					h.hide_stop_result()

		
func _check_station() -> void:
	var track = get_node_or_null("../Track")
	if not track:
		return
	
	at_station = false
	for station in track.get_children():
		var dist = abs(position.x - station.global_position.x)
		
		# Показываем маркер при приближении
		if dist < 400 and speed > 0:
			station.show_marker()
		
		if dist < 150 and speed < 2.0:
			at_station = true
		
