extends Node2D


func _on_easy_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_hard_pressed() -> void:
	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
