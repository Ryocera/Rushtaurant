extends Node

enum Difficulty { EASY, HARD }
enum Stage { STAGE_1, STAGE_2, STAGE_3 }

var current_difficulty = Difficulty.EASY
var current_stage = Stage.STAGE_1
var total_money = 0
var game_time = 60.0
var game_running = false

signal game_over(final_score)

var settings = {
	Difficulty.EASY: {
		"customer_patience": 20.0,
		"cook_time": 3.0,
		"tip_amount": 15000,
	},
	Difficulty.HARD: {
		"customer_patience": 15.0,
		"cook_time": 3.0,
		"tip_amount": 25000,
	}
}

var stage_settings = {
	Stage.STAGE_1: {
		"max_customers": 1,
		"spawn_interval": 12.0,
		"tip_multiplier": 1.0
	},
	Stage.STAGE_2: {
		"max_customers": 2,
		"spawn_interval": 8.0,
		"tip_multiplier": 1.5
	},
	Stage.STAGE_3: {
		"max_customers": 3,
		"spawn_interval": 5.0,
		"tip_multiplier": 2.0
	}
}

func get_setting(key: String):
	if stage_settings[current_stage].has(key):
		return stage_settings[current_stage][key]
	return settings[current_difficulty][key]

func get_tip() -> int:
	var base_tip = settings[current_difficulty]["tip_amount"]
	var multiplier = stage_settings[current_stage]["tip_multiplier"]
	return int(base_tip * multiplier)

func set_difficulty(diff: Difficulty):
	current_difficulty = diff
	print("Difficulty: ", Difficulty.keys()[current_difficulty])

func set_stage(stage: Stage):
	current_stage = stage
	print("Stage: ", Stage.keys()[current_stage])

func start_game():
	total_money = 0
	game_time = 60.0
	game_running = true

func next_stage() -> bool:
	if current_stage < Stage.STAGE_3:
		current_stage += 1
		start_game()
		return true
	return false

func add_money(amount: int):
	total_money += amount

func _process(delta):
	if game_running:
		game_time -= delta
		if game_time <= 0:
			game_time = 0
			game_running = false
			emit_signal("game_over", total_money)
