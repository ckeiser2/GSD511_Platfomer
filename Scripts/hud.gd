extends CanvasLayer

@export var weapon: DartWeapon

@onready var ammo_label: Label = $AmmoLabel
@onready var status_label: Label = $StatusLabel

func _refresh() -> void:
	ammo_label.visible = weapon.equipped
	
	ammo_label.text = "Loaded: %d / %d    Reserve: %d" % [
		weapon.loaded,
		weapon.capacity,
		weapon.reserve
	]
	
	status_label.text = weapon.status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if weapon == null:
		push_error("Assign the player's Weapon node to the HUD.")
		return	
	
	weapon.state_changed.connect(_refresh)
	_refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
