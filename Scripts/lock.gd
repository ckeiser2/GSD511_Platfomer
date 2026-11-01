extends Area2D

signal activated

var is_activated: bool = false

func receive_candy() -> void:
	if is_activated:
		return
		
	is_activated = true
	activated.emit()
