extends CharacterBody2D

var speed = 50
var target_position = Vector2()
var has_reached_target = false
var broken_items = ["mobile_screen", "mobile_battery", "mobile_speaker"]
var selected_item = ""
var has_given_item = false
var waiting_for_repair = false
var current_level = 1
var player_in_range = false

func set_level(level: int) -> void:
	current_level = level

func _ready():
	var available_items = []
	if current_level >= 1:
		available_items.append("mobile_screen")
	if current_level >= 2:
		available_items.append("mobile_battery")
	if current_level >= 3:
		available_items.append("mobile_speaker")
	
	if available_items.is_empty():
		print("Chyba: Žádné dostupné věci pro level ", current_level)
		return
	
	selected_item = available_items[randi() % available_items.size()]
	print("NPC nese: ", selected_item)
	
	var counter = get_node_or_null("/root/Game/CounterPosition")
	if counter:
		target_position = counter.global_position
		print("Cílová pozice: ", target_position)
	else:
		print("Chyba: CounterPosition nenalezen!")
		target_position = Vector2(500, 300)

func _physics_process(_delta):
	if not has_reached_target:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		if global_position.distance_to(target_position) < 20:
			velocity = Vector2.ZERO
			has_reached_target = true
			if not has_given_item:
				print("NPC je u přepážky, čeká na hráče!")
	
	# Kontrola vzdálenosti od hráče
	var player = get_node_or_null("/root/Game/Player")
	if player:
		var distance = global_position.distance_to(player.global_position)
		print("Vzdálenost od hráče: ", distance)  # Debug výpis
		if distance < 50 and has_reached_target and not has_given_item:
			if not player_in_range:
				player_in_range = true
				print("Hráč je v dosahu! Zobrazuji konverzaci.")  # Debug výpis
				show_conversation()
		else:
			if player_in_range:
				player_in_range = false
				print("Hráč opustil dosah! Skrývám konverzaci.")  # Debug výpis
				hide_conversation()

func show_conversation():
	var game = get_node("/root/Game")
	if game:
		var conversation_label = game.get_node_or_null("UILayer/UI/ConversationLabel")
		if conversation_label:
			conversation_label.text = "Dobrý den, potřeboval bych opravit telefon.
			Mám podezření, že to bude (" + selected_item + ").
			Stiskni E pro převzetí."
			conversation_label.visible = true
			print("Konverzace zobrazena: ", conversation_label.text)  # Debug výpis
		else:
			print("Chyba: ConversationLabel nenalezen!")
		# Pokud máš ConversationPanel
		var conversation_panel = game.get_node_or_null("UILayer/UI/ConversationPanel")
		if conversation_panel:
			conversation_panel.visible = true
			print("ConversationPanel zobrazen.")  # Debug výpis
		else:
			print("ConversationPanel nenalezen (to je v pořádku, pokud ho nepoužíváš).")

func hide_conversation():
	var game = get_node("/root/Game")
	if game:
		var conversation_label = game.get_node_or_null("UILayer/UI/ConversationLabel")
		if conversation_label:
			conversation_label.visible = false
			print("Konverzace skryta.")  # Debug výpis
		else:
			print("Chyba: ConversationLabel nenalezen!")
		# Pokud máš ConversationPanel
		var conversation_panel = game.get_node_or_null("UILayer/UI/ConversationPanel")
		if conversation_panel:
			conversation_panel.visible = false
			print("ConversationPanel skryt.")  # Debug výpis

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var player = get_node_or_null("/root/Game/Player")
		if player:
			var distance = global_position.distance_to(player.global_position)
			if distance < 50:
				if has_reached_target and not has_given_item:
					give_item()
				elif waiting_for_repair:
					return_repaired_item("repaired_" + selected_item)

func give_item():
	if not has_given_item:
		print("NPC předává hráči: ", selected_item)
		get_node("/root/Game").add_to_inventory(selected_item)
		has_given_item = true
		waiting_for_repair = true
		hide_conversation()
		print("NPC čeká na opravenou věc!")

func return_repaired_item(repaired_item: String) -> void:
	if waiting_for_repair and repaired_item == "repaired_" + selected_item:
		var game = get_node("/root/Game")
		if repaired_item in game.player_inventory:
			waiting_for_repair = false
			print("NPC dostalo zpět opravenou věc: ", repaired_item)
			game.return_item_to_npc(repaired_item)
			give_reward()
			queue_free()
		else:
			print("Nemáš opravenou věc: ", repaired_item)

func give_reward() -> void:
	var money = 50
	print("NPC dává hráči ", money, " peněz jako odměnu!")
	get_node("/root/Game").add_money(money)
