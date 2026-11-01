extends StaticBody2D

const STEP_SCENE: PackedScene = preload("res://Scenes/dart_step.tscn")

var occupied_positions: Array[Vector2] = []

func create_dart_step(hit_position: Vector2, travel_direction: Vector2) -> void:
		var local_hit: Vector2 = to_local(hit_position)
		var step_y: float = clampf(
			snappedf(local_hit.y, 24.0),
			-144.0,
			-24.0	
		)
		var step_x: float = -28.0 if travel_direction.x > 0.0 else 28.0
		var step_position: Vector2 = Vector2(step_x, step_y)
		
		if occupied_positions.has(step_position):
			return
		
		occupied_positions.append(step_position)
		
		var step := STEP_SCENE.instantiate() as StaticBody2D
		add_child(step)
		step.position = step_position
		
