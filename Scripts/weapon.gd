class_name DartWeapon
extends Node2D
signal state_changed


const PROJECTILE_SCENE: PackedScene = preload("res://Scenes/dart_projectile.tscn")

@export var capacity: int = 6
@export var starting_reserve: int = 8
@export var reload_duration: float = 1.0

var loaded: int = 0
var reserve: int = 0
var reloading: bool = false
var equipped: bool = false
var status: String = "Find the darts"

@onready var muzzle: Marker2D = $Muzzle
@onready var reload_timer: Timer = $ReloadTimer
@onready var visual: Sprite2D = $Visual

func _ready() -> void:

	reload_timer.one_shot = true
	reload_timer.timeout.connect(_finish_reload)
	hide()
	
func equip() -> bool:
	if equipped:
		return false
		
	equipped = true
	loaded = capacity
	reserve = starting_reserve
	status = "Ready"
	show()
	state_changed.emit()
	return true

func update_facing(facing_left:bool) -> void:
	muzzle.position.x = -12.0 if facing_left else 12.0
	visual.position.x = -8.0 if facing_left else 8.0
	visual.flip_h = facing_left

func fire(facing_left: bool, firing_player: Node2D) -> void:
	if not equipped or reloading:
		return
	
	if loaded <= 0:
		status = "Empty - press Q to reload"
		state_changed.emit()
		return
	
	muzzle.position.x = -12.0 if facing_left else 12.0
	
	var projectile := PROJECTILE_SCENE.instantiate() as DartProjectile
	projectile.setup(facing_left,firing_player)
	
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = muzzle.global_position
	loaded -= 1
	status = "Ready" if loaded > 0 else "Empty - press Q to reload"
	state_changed.emit()
	
func reload() -> void:
	if not equipped or reloading:
		return
		
	if loaded >= capacity:
		status = "Magazine full"
		state_changed.emit()
		return
		
	if reserve <= 0:
		status = "No reserve darts"
		state_changed.emit()
		return
		
	reloading = true
	status = "Reloading..."
	state_changed.emit()
	reload_timer.start(reload_duration)
	
func _finish_reload() -> void:
	var needed: int = capacity - loaded
	var transferred: int = mini(needed, reserve)
	
	loaded += transferred
	reserve -= transferred
	
	reloading = false
	status = "Ready"
	state_changed.emit()
	
	
