extends Node2D

const ALEX = preload("res://Scenes/Npc/alex.tscn")
const AMELIA = preload("res://Scenes/Npc/amelia.tscn")
const BOB = preload("res://Scenes/Npc/bob.tscn")

var customers = [ALEX, AMELIA, BOB]
var queue = []

var queue_positions = [
	Vector2(906, 350),
	Vector2(906, 420),
	Vector2(906, 490),
]

var can_spawn = true

func _ready():
	spawn_customer()

func spawn_customer():
	if not can_spawn:
		return
	can_spawn = false
	
	var random_customer = customers[randi() % customers.size()]
	var new_customer = random_customer.instantiate()
	new_customer.position = Vector2(906, 600)
	
	var queue_index = queue.size()
	if queue_index < queue_positions.size():
		new_customer.counter_position = queue_positions[queue_index]
	
	add_child(new_customer)
	queue.append(new_customer)
	new_customer.customer_served.connect(_on_customer_served)

func _on_customer_served(customer):
	queue.erase(customer)
	await get_tree().create_timer(2.0).timeout
	can_spawn = true
	spawn_customer()
