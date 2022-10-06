extends Node

signal coin_count_updated(coin_count)
signal score_updated(score)

# Option variables
var sound_effect_volume := 0.0
var music_volume := 0.0

# Reference variables
onready var world: GameWorld = get_tree().get_root().get_node("Main/World")
onready var ui_manager: UIScreenManager = get_tree().get_root().get_node("Main/UIScreenManager")
onready var file_loader: FileLoader = get_tree().get_root().get_node("Main/FileLoader")

# Data variables
var coin_count := 0 setget set_coin_count
var level_coin_count := 0 # The amount of coins from the last checkpoint

var score := 0 setget set_score
var level_score := 0  # The score from the last checkpoint

var score_orbs := 0
var level_score_orbs := 0

var checkpoint_index := -1

# Permanent user data
var user_coin_count := 0
var user_score_orbs := 0

func _ready() -> void:
	add_to_group("Save")

func set_coin_count(new_count: int) -> void:
	coin_count = new_count
	emit_signal("coin_count_updated", coin_count)

func set_score(new_score: int) -> void:
	score = new_score
	emit_signal("score_updated", score)

func store_level_properties() -> void:
	level_coin_count = coin_count
	level_score = score
	level_score_orbs = score_orbs

func store_user_properties() -> void:
	user_coin_count += coin_count
	user_score_orbs += score_orbs

func save_file(data: Dictionary) -> void:
	data["coins"] = user_coin_count
	data["score_orbs"] = user_score_orbs

func load_file(data: Dictionary) -> void:
	user_coin_count = data["coins"]
	user_score_orbs = data["score_orbs"]
