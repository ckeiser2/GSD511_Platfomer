extends CharacterBody2D


@export var speed = 150.0
@export var jump_height = -400.0


#   := means bool
var is_facing_left := false
var is_double_Jumping := true

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var weapon: DartWeapon = $Weapon

func equip_weapon() -> bool:
	return weapon.equip()

func _physics_process(delta):
	if !is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_height
			animation_player.play("jump")
		elif is_double_Jumping:
			velocity.y = jump_height
			animation_player.play("doublejump")
			is_double_Jumping = false

	var direction = Input.get_axis("move_left", "move_right")
	
	var isMoving : bool = direction!= 0.0

	if isMoving:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	if is_on_floor() && !is_double_Jumping:
			is_double_Jumping = true
	if isMoving:
		is_facing_left = direction < 0.0
		sprite_2d.flip_h = is_facing_left
		
	weapon.update_facing(is_facing_left)
		
	if Input.is_action_just_pressed("reload"):
		weapon.reload()
		
	if Input.is_action_just_pressed("shoot"):
		weapon.fire(is_facing_left, self)
		
	if is_on_floor():
		if isMoving:
			animation_player.play("run")
		else:
			animation_player.play("idle")
	else:			
			
		if velocity.y > 0.0:
			animation_player.play("fall")
			
