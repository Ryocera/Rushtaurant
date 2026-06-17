extends CharacterBody2D

signal order_ready(customer)
signal customer_served(customer)

@onready var label = $OrderBubble/Label
@onready var order_bubble = $OrderBubble
@onready var animated_sprite = $AnimatedSprite2D
@onready var pay_sound = $PaySound
@onready var enter_sound = $EnterSound

var order = "1 Pesanan"
var is_served = false
var counter_position = Vector2.ZERO
var exit_position = Vector2(800, 600)
const SPEED = 80.0
var patience_timer = 0.0
var is_waiting = false
var at_counter = false

enum State { WALKING_IN, WAITING, WALKING_OUT }
var state = State.WALKING_IN

func _ready():
	order_bubble.visible = false
	enter_sound.play()
	if counter_position == Vector2.ZERO:
		var counter = get_tree().get_first_node_in_group("counter")
		if counter:
			counter_position = counter.global_position

func _physics_process(_delta):
	match state:
		State.WALKING_IN:
			walk_to(counter_position)
			if global_position.distance_to(counter_position) < 10:
				arrive_at_counter()
		State.WALKING_OUT:
			walk_to(exit_position)
			if global_position.distance_to(exit_position) < 10:
				queue_free()

func walk_to(target: Vector2):
	var direction = (target - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()
	if direction.x > 0.5:
		animated_sprite.play("run_right")
	elif direction.x < -0.5:
		animated_sprite.play("run_left")
	elif direction.y < -0.5:
		animated_sprite.play("run_up")
	elif direction.y > 0.5:
		animated_sprite.play("run_down")

func arrive_at_counter():
	state = State.WAITING
	velocity = Vector2.ZERO
	animated_sprite.play("idle_up")
	at_counter = true
	# set timer sabar dari GameManager
	patience_timer = GameManager.get_setting("customer_patience")
	is_waiting = true
	await get_tree().create_timer(0.5).timeout
	show_order()
	var counter = get_tree().get_first_node_in_group("counter")
	if counter:
		counter.customer_arrived(self)

func show_order():
	label.text = "!"
	order_bubble.visible = true
	emit_signal("order_ready", self)

func receive_food():
	if is_served:
		return
	is_served = true
	is_waiting = false
	order_bubble.visible = false
	pay_sound.play()
	emit_signal("customer_served", self)
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.add_score(GameManager.get_tip())  # ← pakai get_tip()
	await get_tree().create_timer(1.0).timeout
	leave()

func leave():
	state = State.WALKING_OUT

func _process(delta):
	if order_bubble.visible:
		label.modulate.a = abs(sin(Time.get_ticks_msec() * 0.005))
	if is_waiting:
		patience_timer -= delta
		if patience_timer <= 0:
			leave_angry()

func leave_angry():
	is_waiting = false
	order_bubble.visible = false
	emit_signal("customer_served", self)
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.add_score(-5000)
	await get_tree().create_timer(0.5).timeout
	leave()
