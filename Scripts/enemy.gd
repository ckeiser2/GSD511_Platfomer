extends CharacterBody2D

var speed := 50.0
var direction := 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var l_ray_cast_2d: RayCast2D = $L_RayCast2D
@onready var r_ray_cast_2d: RayCast2D= $R_RayCast2D
@onready var l_ray_cast_wall: RayCast2D = $L_RayCast2DWall
@onready var r_ray_cast_wall: RayCast2D = $R_RayCast2DWall
@onready var animation_player = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
		
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
