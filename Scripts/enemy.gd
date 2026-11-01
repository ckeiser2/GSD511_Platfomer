extends CharacterBody2D

var speed := 50.0

@export_range(0.1, 5.0, 0.1) var stun_duration: float = 2.0
@export var stun_color: Color = Color(0.6, 0.7, 1.0, 1.0)

var direction := 1.0

var stun_time_left: float = 0.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var normal_color: Color = sprite_2d.modulate

@onready var l_ray_cast_2d: RayCast2D = $L_RayCast2D
@onready var r_ray_cast_2d: RayCast2D= $R_RayCast2D
@onready var l_ray_cast_wall: RayCast2D = $L_RayCast2DWall
@onready var r_ray_cast_wall: RayCast2D = $R_RayCast2DWall
@onready var animation_player = $AnimationPlayer

func stun() -> void:
	stun_time_left = stun_duration
	velocity.x = 0.0
	sprite_2d.modulate = stun_color
	animation_player.pause()

func _finish_stun() -> void:
	sprite_2d.modulate = normal_color
	animation_player.play("run")

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	if stun_time_left > 0.0:
		stun_time_left = maxf(stun_time_left - delta, 0.0)
		velocity.x = 0.0
		move_and_slide()
		
		if stun_time_left <= 0.0:
			_finish_stun()
			
		return
		
	if !l_ray_cast_2d.is_colliding() || !r_ray_cast_2d.is_colliding():
		direction *= -1.0

	if l_ray_cast_wall.is_colliding() || r_ray_cast_wall.is_colliding():
		direction *= -1.0
		
	velocity.x = direction * speed
	var isMoving : bool = direction!= 0.0

	move_and_slide()
	
	sprite_2d.flip_h = direction < 0.0
	
	if is_on_floor():
		if isMoving:
			animation_player.play("run")
		else:
			animation_player.play("idle")
