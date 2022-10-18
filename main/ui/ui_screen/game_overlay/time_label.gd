extends Label
class_name TimeLabel

var start_time := 0
var elapsed := 0

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_timeout")

func start() -> void:
	start_time = OS.get_ticks_msec()
	$Timer.start(1)

func stop() -> int:
	$Timer.stop()
	return get_elapsed()

func get_elapsed() -> int:
	return elapsed

func _on_timeout() -> void:
	elapsed += OS.get_ticks_msec() - start_time
	start_time = OS.get_ticks_msec()
	var secs = int(round((elapsed) / 1000.0))
	var mins = secs / 60
	if mins > 9:
		text = "9:59"
	else:
		secs = secs % 60
		text = "%01d:%02d" % [mins, secs]
	
