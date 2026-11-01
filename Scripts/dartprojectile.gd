class_name DartProjectile
extends Area2D

@export var speed: float = 250.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var time_alive: float = 0.0
var shooter: Node2D
var hit_processed: bool = false

func setup(facing_left: bool, firing_player:Node2D) -> void:
	direction = Vector2.LEFT if facing_left else Vector2.RIGHT
	shooter = firing_player
	
	if facing_left:
		$Polygon2D.scale.x = -1.0
	else:
		$Polygon2D.scale.x = 1.0
	
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	if hit_processed:
		return
	
	if not area.has_method("receive_candy"):
		return
	
	hit_processed = true
	area.call("receive_candy")
	queue_free()

func _physics_process(delta: float) -> void:
	if hit_processed:
		return
		
	time_alive += delta
	
	if time_alive >= lifetime:
		queue_free()
		return
		
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body == shooter or hit_processed:
		return 
		
	hit_processed = true
	
	if body.has_method("create_dart_step"):
		body.call_deferred(
			"create_dart_step",
			global_position,
			direction
		)
	elif body.has_method("stun"):
		body.call("stun")
	
	if body.has_method("stun"):
		body.call("stun")
	
	hit_processed = true
	print("Dart hit: ", body.name)
	queue_free()
