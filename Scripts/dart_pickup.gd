extends Area2D

var nearby_player: Node2D

var collected: bool = false

@onready var prompt: Label = $Prompt


func _ready() -> void:
	prompt.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void: 
	if collected or not is_instance_valid(nearby_player):
		return
	if Input.is_action_just_pressed("interact"):
		if nearby_player.call("equip_weapon"):
			collected = true
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("equip_weapon"):
		nearby_player = body
		prompt.show()


func _on_body_exited(body: Node2D) -> void:
	if body == nearby_player:
		nearby_player = null
		prompt.hide()
