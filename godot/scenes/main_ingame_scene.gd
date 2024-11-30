extends Node3D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay

@onready var camera = $Camera3D
@onready var raycast : RayCast3D = $RayCast3D
@onready var grid_map : GridMap = $GridMap
@onready var path_follow : PathFollow3D = $Path3D/PathFollow3D

var new_tile_id = 0
var PATH_SPEED := 1
var current_path_speed = PATH_SPEED
var on_break = false

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#_walk(delta)
	pass

func _walk(delta: float) -> void:
	if !on_break:
		path_follow.loop = false
		path_follow.progress += delta * current_path_speed;
		
		if path_follow.progress == 0:
			current_path_speed = 0 
			await get_tree().create_timer(2.0).timeout
			current_path_speed = PATH_SPEED
	
func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
	if event.is_action_pressed("confirm_ability_placement"):
		# Get the mouse position in the viewport
		var mouse_position = event.position
		
		# Calculate the ray origin and direction
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_direction = camera.project_ray_normal(mouse_position)
		
		# Configure the RayCast3D
		raycast.transform.origin = Vector3(ray_origin)
		raycast.target_position = ray_origin + ray_direction * camera.far
		raycast.enabled = true
		raycast.force_raycast_update()
		
		# Check for collision
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			var collision_point = raycast.get_collision_point()
			print("Collided with:", collider)
			print("Collision point:", collision_point)
			
			var local_pos = grid_map.to_local(collision_point)
			var grid_coords = grid_map.local_to_map(local_pos)
			
			# Get the current tile
			var tile_id = grid_map.get_cell_item(Vector3i(grid_coords))
			print("Clicked Tile ID:", tile_id)
			# Change the tile to a new one (if needed)
			grid_map.set_cell_item(Vector3i(grid_coords), new_tile_id)
			
			_spawn_object(stone)
		else:
			print("No collision detected.")
			
	if event.is_action_pressed("use_ability_1"):
		# current_path_speed *= -1	
		pass

func _spawn_object(obj, pos: Vector3):
	var object = obj.instantiate()
	add_child(object)
	var aaaa = object.get_position()
	pass

func _save_game() -> void:
	SaveGame.save_game(get_tree())
