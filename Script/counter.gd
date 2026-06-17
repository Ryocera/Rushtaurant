extends Area2D

var player_inside = false
var player_ref = null
var customer_queue = []

@onready var order_sound = $OrderSound

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		player_ref = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		player_ref = null

func _input(event):
	if event.is_action_pressed("interact"):
		if player_inside and player_ref:
			var current_customer = customer_queue.front() if customer_queue.size() > 0 else null
			if player_ref.state == player_ref.State.IDLE and current_customer:
				if current_customer.at_counter:
					order_sound.play()
					player_ref.receive_order(current_customer.order)
			elif player_ref.state == player_ref.State.HAS_FOOD:
				if current_customer and current_customer.at_counter:
					player_ref.serve_food()
					current_customer.receive_food()
					customer_queue.pop_front()

func customer_arrived(customer):
	customer_queue.append(customer)
