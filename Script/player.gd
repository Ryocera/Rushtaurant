extends CharacterBody2D

const SPEED = 300.0
var last_direction: Vector2 = Vector2.RIGHT

enum State { IDLE, HAS_ORDER, HAS_FOOD }
var state = State.IDLE
var current_order = ""

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
	process_movement()
	move_and_slide()
	process_animation()

func _input(event):
	if event.is_action_pressed("interact"):
		print("Interact ditekan, state: ", State.keys()[state])

func receive_order(order: String):
	if state == State.IDLE:
		current_order = order
		state = State.HAS_ORDER
		print("Order diterima: ", current_order)

func receive_food():
	if state == State.HAS_ORDER:
		state = State.HAS_FOOD
		print("Makanan siap!")

func serve_food():
	if state == State.HAS_FOOD:
		state = State.IDLE
		current_order = ""
		print("Makanan disajikan!")

func process_movement():
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO

func process_animation():
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2):
	if dir.x > 0:
		animated_sprite_2d.play(prefix + "_right")
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + "_left")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")
