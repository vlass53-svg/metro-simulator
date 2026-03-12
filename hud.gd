extends CanvasLayer

@onready var speed_label = $SpeedLabel
@onready var ars_label = $ARSLabel
@onready var throttle_label = $ThrottleLabel
@onready var brake_label = $BrakeLabel
@onready var signal_rect = $SignalRect

func refresh(spd, ars, thr, brk, sig):
	speed_label.text = "Скорость: %d км/ч" % int(spd)
	ars_label.text = "АРС: %d км/ч" % int(ars)
	throttle_label.text = "Тяга: %d" % thr
	brake_label.text = "Тормоз: %d" % brk
	match sig:
		0: signal_rect.color = Color.GREEN
		1: signal_rect.color = Color(1, 1, 0)
		2: signal_rect.color = Color.YELLOW
		3: signal_rect.color = Color.RED
		4: signal_rect.color = Color.WHITE
