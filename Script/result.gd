extends Node2D

@onready var score_label = $Control/ScoreLabel
@onready var stage_label = $Control/StageLabel

func _ready():
	score_label.text = format_rupiah(GameManager.total_money)
	stage_label.text = "Stage " + str(GameManager.current_stage + 1)

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


func _on_again_pressed() -> void:
	GameManager.start_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_next_pressed() -> void:
	if not GameManager.next_stage():
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_pressed() -> void:
	GameManager.set_stage(GameManager.Stage.STAGE_1)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_pressed() -> void:
	pass # Replace with function body.
