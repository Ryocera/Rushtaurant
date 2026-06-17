extends Area2D

signal cooking_started
signal cooking_progress(value)
signal cooking_finished

var player_inside = false
var player_ref = null
var is_cooking = false

@onready var timer = $CookingTimer
@onready var cook_sound = $CookSound

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(_on_cooking_done)
	timer.wait_time = GameManager.get_setting("cook_time")

func _physics_process(_delta):
	if is_cooking:
		emit_signal("cooking_progress", 3.0 - timer.time_left)
	if player_inside and player_ref:
		if Input.is_action_just_pressed("interact"):
			if player_ref.state == player_ref.State.HAS_ORDER and not is_cooking:
				start_cooking()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		player_ref = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		player_ref = null

func start_cooking():
	is_cooking = true
	cook_sound.play()
	emit_signal("cooking_started")
	timer.start()

func _on_cooking_done():
	is_cooking = false
	emit_signal("cooking_finished")
	if player_ref:
		player_ref.receive_food()
