extends CanvasLayer

@onready var progress_bar = $ProgressBar
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel

var score = 0

func _ready():
	progress_bar.visible = false
	progress_bar.max_value = 3.0
	progress_bar.value = 0.0
	score_label.text = "Rp 0"
	timer_label.text = "60"
	
	# cek dulu sebelum connect
	if not GameManager.game_over.is_connected(_on_game_over):
		GameManager.game_over.connect(_on_game_over)
	
	GameManager.start_game()
	
	var stoves = get_tree().get_nodes_in_group("stove")
	for stove in stoves:
		stove.cooking_started.connect(_on_cooking_started)
		stove.cooking_progress.connect(_on_cooking_progress)
		stove.cooking_finished.connect(_on_cooking_finished)

func _process(_delta):
	if GameManager.game_running:
		timer_label.text = str(ceil(GameManager.game_time))

func add_score(amount: int):
	score += amount
	GameManager.add_money(amount)
	score_label.text = format_rupiah(score)

func _on_game_over(final_score):
	print("Game over! Final score: ", final_score)
	var path = ""
	
	if final_score >= 75000:
		path = "res://scenes/Result/Result_b3.tscn"
	elif final_score >= 50000:
		path = "res://scenes/Result/Result_b2.tscn"
	elif final_score >= 35000:
		path = "res://scenes/Result/Result_b1.tscn"
	else:
		path = "res://scenes/Result/Result_fail.tscn"
	
	print("Mencoba pindah ke: ", path)
	var err = get_tree().change_scene_to_file(path)
	print("Error code: ", err)

func format_rupiah(amount: int) -> String:
	var str_amount = str(max(0, amount))
	var result = ""
	var count = 0
	for i in range(str_amount.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			result = "." + result
		result = str_amount[i] + result
		count += 1
	return "Rp " + result

func _on_cooking_started():
	progress_bar.visible = true
	progress_bar.value = 0.0

func _on_cooking_progress(value):
	progress_bar.value = value

func _on_cooking_finished():
	progress_bar.visible = false
	progress_bar.value = 0.0
