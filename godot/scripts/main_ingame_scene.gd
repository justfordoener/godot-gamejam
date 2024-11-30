extends Node3D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@onready var pathing_manager = $PathingManager
@onready var camera = $Camera3D
@onready var raycast : RayCast3D = $RayCast3D
@onready var grid_map : GridMap = $GridMap

var stone = preload("res://assets/stone.tscn")

var new_tile_id = 0

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
func _process(delta: float) -> void:
	pass
	
func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
	if event.is_action_pressed("use_ability_1") and not pause_overlay.visible:
		pathing_manager.snowmen_activated = true
		
		
	if event.is_action_pressed("confirm_ability_placement") and not pause_overlay.visible:
		# Get the mouse position in the viewport
		var mouse_position = event.position		
		
		# Calculate the ray origin and direction
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_direction = camera.project_ray_normal(mouse_position)
		
		# Configure the RayCast3D
		raycast.enabled = true
		raycast.transform.origin = Vector3(ray_origin)
		raycast.target_position = ray_origin + ray_direction * camera.far
		raycast.force_raycast_update()
		
		# Check for collision
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			var collision_point = raycast.get_collision_point()			
			var local_pos = grid_map.to_local(collision_point)
			var grid_coords = grid_map.local_to_map(local_pos)
			_spawn_object(stone, Vector3(grid_coords))
		else:
			print("No collision detected.")

func _spawn_object(obj, pos: Vector3):
	var object : Node3D = obj.instantiate()
	object.transform.origin = pos + Vector3(0.5, 0.5, 0.5)
	add_child(object)
	pass


func _save_game() -> void:
	SaveGame.save_game(get_tree())
