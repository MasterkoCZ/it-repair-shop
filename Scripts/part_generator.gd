extends Node2D

@export var part_type: String = "new_screen"
@export var generation_interval: float = 20.0
@export var upgrade_cost: int = 100
@export var max_level: int = 3
var current_level: int = 1
var intervals_per_level = [20.0, 15.0, 10.0]
var time_since_last_generation: float = 0.0
var part_available: bool = false
var player_inside: bool = false

func _ready() -> void:
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)
	generation_interval = intervals_per_level[current_level - 1]
	print("Generátor ", part_type, " na úrovni ", current_level, " (interval: ", generation_interval, "s)")
	update_info_label()  # Inicializace textu při startu

func _process(delta: float) -> void:
	if not part_available:
		time_since_last_generation += delta
		if time_since_last_generation >= generation_interval:
			part_available = true
			time_since_last_generation = 0.0
			print("Generátor vytvořil díl: ", part_type)
	
	update_info_label()  # Aktualizace textu v každém snímku

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside and part_available:
		var game = get_node("/root/Game")
		game.repair_parts[part_type] += 1  # Přidáme 1 díl do slovníku
		part_available = false
		print("Sebral jsi díl z generátoru: ", part_type, " (celkem: ", game.repair_parts[part_type], ")")
		game.update_parts_ui()
	
	if event.is_action_pressed("upgrade") and player_inside:
		upgrade_generator()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false

func upgrade_generator() -> void:
	var game = get_node("/root/Game")
	if current_level >= max_level:
		print("Generátor ", part_type, " je už na maximální úrovni!")
		return
	
	if game.player_money >= upgrade_cost:
		game.player_money -= upgrade_cost
		current_level += 1
		generation_interval = intervals_per_level[current_level - 1]
		game.update_money_ui()
		print("Generátor ", part_type, " vylepšen na úroveň ", current_level, " (interval: ", generation_interval, "s)")
	else:
		print("Nemáš dost peněz na vylepšení! Potřebuješ ", upgrade_cost, " peněz.")

func update_info_label() -> void:
	var label = $InfoLabel
	if label:
		var remaining_time = max(0, generation_interval - time_since_last_generation) if not part_available else 0
		if part_available:
			label.text = "Level: " + str(current_level) + ", Ready!"
		else:
			label.text = "Level: " + str(current_level) + ", Time: " + str(snapped(remaining_time, 0.1)) + "s"
	else:
		print("Chyba: InfoLabel nenalezen!")
