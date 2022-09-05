extends Node

signal coin_count_updated(coin_count)
signal score_updated(score)

# Option variables
var sound_effect_volume := 0.0
var music_volume := 0.0

# Reference variables
onready var world: GameWorld = get_tree().get_root().get_node("Main/World")

# Data variables

var coin_count := 0 setget set_coin_count
var score := 0 setget set_score

func set_coin_count(new_count: int) -> void:
	coin_count = new_count
	emit_signal("coin_count_updated", coin_count)

func set_score(new_score: int) -> void:
	score = new_score
	emit_signal("score_updated", score)
