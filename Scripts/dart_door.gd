extends Node2D

var is_open: bool = false

@onready var lock = $Lock
@onready var door_collision: CollisionShape2D = $DoorBody/CollisionShape2D

func _ready() -> void:
	lock.activated.connect(_open)
	
func _open() -> void:
	if is_open:
		return
	
	is_open = true
	hide()
	door_collision.set_deferred("disabled", true)
	lock.set_deferred("monitorable", false)
