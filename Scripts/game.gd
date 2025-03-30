extends Node2D

var npc_scene = preload("res://Scenes/npc.tscn")
var part_generator_scene = preload("res://Scenes/part_generator.tscn")
var spawn_timer = 0.0
var spawn_interval = 30.0
var player_inventory = []
var repair_parts = {"new_screen": 0, "new_battery": 0, "new_speaker": 0}
var item_icons = {
	"mobile_screen_bad": preload("res://Moje grafika/Items/Mobile_screen_bad.png"),
	"mobile_screen_good": preload("res://Moje grafika/Items/Mobile.png"),
	"mobile_battery_bad": preload("res://Moje grafika/Items/Mobile_battery_bad.png"),
	"mobile_battery_good": preload("res://Moje grafika/Items/Mobile_battery_good.png"),
	"mobile_speaker_bad": preload("res://Moje grafika/Items/Mobile_speaker_bad.png"),
	"mobile_speaker_good": preload("res://Moje grafika/Items/Mobile_speaker_good.png")
}
var is_repairing = false
var repair_time = 10.0
var current_repair_time = 0.0
var item_being_repaired = ""
var player_money = 0
var can_repair = false
var current_level = 1
var money_to_next_level = [200, 500]
var available_items_per_level = [
	["mobile_screen"],
	["mobile_screen", "mobile_battery"],
	["mobile_screen", "mobile_battery", "mobile_speaker"]
]
var repaired_devices = 0
var owned_generators = ["new_screen"]
var inventory_visible = false  # Sledujeme, jestli je inventář viditelný

func _ready() -> void:
	print("Hra startuje! Level: ", current_level)
	if npc_scene:
		print("NPC scéna načtena.")
		spawn_npc()
	else:
		print("Chyba: NPC scéna nenalezena!")
	
	for part_type in owned_generators:
		spawn_generator(part_type)
	
	print("Dostupné díly: ", repair_parts)
	
	# Skryjeme InventoryList, PartsList a RepairProgress na začátku
	if $UILayer/UI/InventoryList:
		$UILayer/UI/InventoryList.visible = false
	else:
		print("Chyba: InventoryList nenalezen!")
	
	if $UILayer/UI/PartsList:
		$UILayer/UI/PartsList.visible = false
	else:
		print("Chyba: PartsList nenalezen!")
	
	if $UILayer/UI/RepairProgress:
		$UILayer/UI/RepairProgress.visible = false
	else:
		print("Chyba: RepairProgress nenalezen!")
	
	# Zajistíme, že MoneyLabel a LevelLabel jsou viditelné
	if $UILayer/UI/MoneyLabel:
		$UILayer/UI/MoneyLabel.visible = true
	else:
		print("Chyba: MoneyLabel nenalezen!")
	
	if $UILayer/UI/LevelLabel:
		$UILayer/UI/LevelLabel.visible = true
	else:
		print("Chyba: LevelLabel nenalezen!")
	
	if $UILayer/UI/InventoryList:
		$UILayer/UI/InventoryList.item_selected.connect(_on_inventory_item_selected)
	else:
		print("Chyba: InventoryList nenalezen pro připojení signálu!")
	
	update_money_ui()
	update_level_ui()

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_npc()
		spawn_timer = 0.0
	
	if is_repairing:
		if can_repair:
			current_repair_time += delta
			if $UILayer/UI/RepairProgress:
				$UILayer/UI/RepairProgress.value = current_repair_time
			if current_repair_time >= repair_time:
				finish_repair()
		else:
			is_repairing = false
			current_repair_time = 0.0
			if $UILayer/UI/RepairProgress:
				$UILayer/UI/RepairProgress.value = 0
				$UILayer/UI/RepairProgress.visible = false
			print("Oprava přerušena: Odešel jsi od stolu!")

func spawn_npc():
	print("Spawnuje se NPC!")
	var npc = npc_scene.instantiate()
	if $SpawnPoint:
		npc.position = $SpawnPoint.global_position
		print("NPC spawnuté na: ", npc.position)
	else:
		npc.position = Vector2(100, 300)
		print("SpawnPoint nenalezen! NPC na: ", npc.position)
	npc.set_level(current_level)
	add_child(npc)

func add_to_inventory(item: String) -> void:
	player_inventory.append(item)
	print("Inventář hráče: ", player_inventory)
	if inventory_visible:  # Aktualizujeme UI jen pokud je inventář viditelný
		update_inventory_ui()

func _on_inventory_item_selected(integer: int) -> void:
	if integer < player_inventory.size():
		var item = player_inventory[integer]
		if not is_repairing and can_repair and not item.begins_with("repaired_"):
			var required_part = ""
			if "screen" in item:
				required_part = "new_screen"
			elif "battery" in item:
				required_part = "new_battery"
			elif "speaker" in item:
				required_part = "new_speaker"
			
			if repair_parts.has(required_part) and repair_parts[required_part] > 0:
				is_repairing = true
				current_repair_time = 0.0
				item_being_repaired = item
				if $UILayer/UI/RepairProgress:
					$UILayer/UI/RepairProgress.value = 0
					$UILayer/UI/RepairProgress.visible = true
				if $RepairSound and not $RepairSound.playing:
					$RepairSound.play()
				$UILayer/UI/InventoryList.deselect_all()
				print("Začíná oprava: ", item)
			else:
				print("Chybí díl: ", required_part)
		else:
			if not can_repair:
				print("Musíš být u opravářského stolu, abys mohl opravovat!")

func finish_repair() -> void:
	is_repairing = false
	player_inventory.erase(item_being_repaired)
	var required_part = ""
	if "screen" in item_being_repaired:
		required_part = "new_screen"
	elif "battery" in item_being_repaired:
		required_part = "new_battery"
	elif "speaker" in item_being_repaired:
		required_part = "new_speaker"
	repair_parts[required_part] -= 1
	if repair_parts[required_part] <= 0:
		repair_parts[required_part] = 0
	print("Opraveno: ", item_being_repaired, " pomocí ", required_part)
	player_inventory.append("repaired_" + item_being_repaired)
	repaired_devices += 1
	if $RepairSound and $RepairSound.playing:
		$RepairSound.stop()
	check_generator_unlock()
	print("Nový inventář: ", player_inventory)
	if inventory_visible:
		update_inventory_ui()
		update_parts_ui()
	if $UILayer/UI/RepairProgress:
		$UILayer/UI/RepairProgress.value = 0
		$UILayer/UI/RepairProgress.visible = false

func return_item_to_npc(repaired_item: String) -> void:
	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc.has_method("return_repaired_item"):
			npc.return_repaired_item(repaired_item)
			player_inventory.erase(repaired_item)
			if inventory_visible:
				update_inventory_ui()
			break

func add_money(amount: int) -> void:
	player_money += amount
	print("Hráč má teď ", player_money, " peněz.")
	update_money_ui()
	check_level_up()

func check_level_up() -> void:
	if current_level - 1 < money_to_next_level.size() and player_money >= money_to_next_level[current_level - 1]:
		current_level += 1
		print("Postoupil jsi na Level ", current_level, "!")
		update_level_ui()

func check_generator_unlock() -> void:
	if repaired_devices >= 2 and not "new_battery" in owned_generators:
		owned_generators.append("new_battery")
		spawn_generator("new_battery")
		print("Odemkl jsi generátor na new_battery! (2 opravená zařízení)")
	elif repaired_devices >= 4 and not "new_speaker" in owned_generators:
		owned_generators.append("new_speaker")
		spawn_generator("new_speaker")
		print("Odemkl jsi generátor na new_speaker! (4 opravená zařízení)")

func spawn_generator(part_type: String) -> void:
	var generator = part_generator_scene.instantiate()
	generator.part_type = part_type
	
	var spawn_point = null
	if part_type == "new_screen":
		spawn_point = get_node_or_null("ScreenGeneratorSpawn")
	elif part_type == "new_battery":
		spawn_point = get_node_or_null("BatteryGeneratorSpawn")
	elif part_type == "new_speaker":
		spawn_point = get_node_or_null("SpeakerGeneratorSpawn")
	
	if spawn_point:
		generator.position = spawn_point.global_position
		print("Generátor ", part_type, " spawnut na: ", generator.position)
	else:
		generator.position = Vector2(600, 100)
		print("Spawn point pro ", part_type, " nenalezen! Použita záložní pozice: ", generator.position)
	
	add_child(generator)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_visible = !inventory_visible
		$UILayer/UI/InventoryList.visible = inventory_visible
		$UILayer/UI/PartsList.visible = inventory_visible
		$UILayer/UI/RepairProgress.visible = inventory_visible and is_repairing
		print("Inventář viditelnost změněna na: ", inventory_visible)
		if inventory_visible:
			update_inventory_ui()
			update_parts_ui()

func update_inventory_ui() -> void:
	var inventory_list = $UILayer/UI/InventoryList
	if inventory_list:
		inventory_list.clear()
		for item in player_inventory:
			var icon = null
			if item.begins_with("repaired_"):
				var base_item = item.replace("repaired_", "")
				icon = item_icons.get(base_item + "_good", null)
				inventory_list.add_item("Opraveno: " + base_item, icon)
			else:
				icon = item_icons.get(item + "_bad", null)
				inventory_list.add_item(item, icon)
	else:
		print("Chyba: InventoryList nenalezen při aktualizaci!")

func update_money_ui() -> void:
	var money_label = $UILayer/UI/MoneyLabel
	if money_label:
		money_label.text = "Peníze: " + str(player_money)
	else:
		print("Chyba: MoneyLabel nenalezen!")

func update_parts_ui() -> void:
	var parts_list = $UILayer/UI/PartsList
	if parts_list:
		parts_list.clear()
		for part in repair_parts.keys():
			if repair_parts[part] > 0:
				parts_list.add_item(part + ": " + str(repair_parts[part]))
	else:
		print("Chyba: PartsList nenalezen při aktualizaci!")

func update_level_ui() -> void:
	var level_label = $UILayer/UI/LevelLabel
	if level_label:
		level_label.text = "Level: " + str(current_level)
	else:
		print("Chyba: LevelLabel nenalezen!")

func set_can_repair(value: bool) -> void:
	can_repair = value
