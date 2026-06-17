extends Control

@onready var result_image = $ResultImage
@onready var score_label = $ScoreLabel
@onready var result_label = $ResultLabel

# load semua asset hasil
const IMG_B1 = preload("res://assets/images/result_b1.png")
const IMG_B2 = preload("res://assets/images/result_b2.png")
const IMG_B3 = preload("res://assets/images/result_b3.png")
const IMG_FAIL = preload("res://assets/images/result_fail.png")

func _ready():
	var final_score = GameManager.total_money
	score_label.text = format_rupiah(final_score)
	show_result(final_score)

func show_result(score: int):
	if score >= 150000:
		result_image.texture = IMG_B1
		result_label.text = "B1 - Luar Biasa!"
	elif score >= 100000:
		result_image.texture = IMG_B2
		result_label.text = "B2 - Bagus!"
	elif score >= 50000:
		result_image.texture = IMG_B3
		result_label.text = "B3 - Cukup Baik"
	else:
		result_image.texture = IMG_FAIL
		result_label.text = "Gagal - Coba Lagi!"

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

func _on_retry_button_pressed():
	GameManager.start_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
