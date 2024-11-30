extends Node

@onready var grid_map : GridMap = $"../GridMap"

var MOVEMENT_SPEED := 1
@onready var NPC_COUNT := 1
var movement_speed_0 = MOVEMENT_SPEED
var movement_speed_1 = MOVEMENT_SPEED
var movement_speed = [NPC_COUNT]
var is_moving_0 = true
var is_moving_1 = true
var is_moving = [NPC_COUNT]
@onready var path_follow_0 : PathFollow3D = $"../Path3D/PathFollow3D"
@onready var path_follow_1 : PathFollow3D #= $"../Path3D/PathFollow3D"
var path_follow = [NPC_COUNT]
@onready var raycast_0 : RayCast3D = $"../Path3D/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_1 : RayCast3D #= $"../Path3D/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
var raycast = [NPC_COUNT]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow_0.loop = false
	#path_follow_1.loop = false
	movement_speed[0] = movement_speed_0
	#movement_speed[1] = movement_speed_1
	is_moving[0] = is_moving_0
	#is_moving[1] = is_moving_1
	path_follow[0] = path_follow_0
	#path_follow[1] = path_follow_1
	raycast[0] = raycast_0
	#raycast[1] = raycast_1
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move npc #0
	_move_npc(delta, 0) #is_moving_0, path_follow_0, movement_speed_0)
	_check_collision(0) #raycast_0, is_moving_0)
	
	# move npc #1
	#_move_npc(delta, is_moving_1 ,path_follow_1, movement_speed_1)
	#_check_collision(raycast_1, is_moving_1)
	


func _check_collision(num: int) -> void:
	if raycast[num].is_colliding() and is_moving[num]:
			is_moving[num] = false
			var col = raycast[num].get_collider()
			if col:
				print("collided with: " + col.name)
				await get_tree().create_timer(2.0).timeout
				col.get_owner().queue_free()
			is_moving[num] = true
			

func _move_npc(delta: float, num: int) -> void:
	if is_moving[num]:
		path_follow[num].progress += delta * movement_speed[num]
