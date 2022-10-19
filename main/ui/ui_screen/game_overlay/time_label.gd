extends Label
class_name TimeLabel

var elapsed := 0

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_timeout")

func start() -> void:
	elapsed = 0
	$Timer.start(1)

func stop() -> int:
	$Timer.stop()
	return get_elapsed()

func get_elapsed() -> int:
	return elapsed

func _on_timeout() -> void:
	elapsed += 1
	var secs = elapsed
	var mins = secs / 60
	if mins > 9:
		text = "9:59"
	else:
		secs = secs % 60
		text = "%01d:%02d" % [mins, secs]
	
