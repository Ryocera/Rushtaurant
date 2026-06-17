extends Control

@onready var story_label = $StoryLabel

const STORIES = [
	"Sebuah kedai tua di sudut kota kecil, tempat aroma kaldu hangat dan tawa renyah selalu menyambutku.",
	"Suatu hari, sebuah surat dengan tulisan tanganr tiba di mejaku",
	"'Restoran kecil kita kini sudah lama terkunci, namun resep rahasia di dalamnya tidak boleh padam..'",
	"Hari ini, aku berdiri di depan pintu kayu yang berdebu itu",
	"Kunci kuningan di tanganku terasa berat, namun penuh harapan.",
]

var current_line = 0
var displayed_text = ""
var char_index = 0
var is_typing = false

func _ready():
	story_label.text = ""
	await get_tree().create_timer(0.5).timeout
	type_next_line()

func type_next_line():
	if current_line >= STORIES.size():
		go_to_menu()
		return
	
	displayed_text = ""
	char_index = 0
	is_typing = true
	story_label.text = ""
	type_character()

func type_character():
	if char_index < STORIES[current_line].length():
		displayed_text += STORIES[current_line][char_index]
		story_label.text = displayed_text
		char_index += 1
		await get_tree().create_timer(0.05).timeout
		type_character()
	else:
		is_typing = false
		await get_tree().create_timer(1.5).timeout
		current_line += 1
		type_next_line()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		if is_typing:
			# skip typing langsung tampil semua
			story_label.text = STORIES[current_line]
			is_typing = false
		else:
			# lanjut ke baris berikutnya
			current_line += 1
			type_next_line()


func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_skip_pressed() -> void:
	go_to_menu()
