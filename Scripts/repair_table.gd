extends Node2D

var player_inside = false

func _ready() -> void:
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_inside = true
		get_node("/root/Game").set_can_repair(true)

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false
		get_node("/root/Game").set_can_repair(false)
