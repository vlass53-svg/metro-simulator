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

func _process(delta: float) -> void:
	_update_speed(delta)
	_check_ars()
	_move(delta)
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

@onready var hud = get_node_or_null("HUD")

func _update_hud() -> void:
	if hud:
		hud.refresh(speed, ars_limit, throttle_notch, brake_notch, current_signal)

# === Ввод игрока ===
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throttle_up"):
		throttle_notch = min(4, throttle_notch + 1)
		brake_notch = 0
		print("Тяга: ", throttle_notch)
	
	if event.is_action_pressed("throttle_down"):
		throttle_notch = max(0, throttle_notch - 1)
		print("Тяга: ", throttle_notch)
	
	if event.is_action_pressed("brake_up"):
		brake_notch = min(7, brake_notch + 1)
		throttle_notch = 0
		print("Тормоз: ", brake_notch)
	
	if event.is_action_pressed("brake_down"):
		brake_notch = max(0, brake_notch - 1)
		print("Тормоз: ", brake_notch)
	
	if event.is_action_pressed("emergency_brake"):
		speed = max(0.0, speed - emergency_brake)
		brake_notch = 7
		throttle_notch = 0
		print("ЭКСТРЕННОЕ ТОРМОЖЕНИЕ!")
