extends Node

@onready var grid_map : GridMap = $"../GridMap"

var MOVEMENT_SPEED := 1
var NPC_COUNT := 1
var BOCK_COST := -10
var movement_speed_0 = MOVEMENT_SPEED
var movement_speed_1 = MOVEMENT_SPEED
var movement_speed = [NPC_COUNT]
var is_moving_0 = true
var is_moving_1 = true
var is_moving = [NPC_COUNT]
@onready var path_follow_0 : PathFollow3D = $"../path_npc_0/PathFollow3D"
@onready var path_follow_1 : PathFollow3D #= $"../Path3D/PathFollow3D"
var path_follow = [NPC_COUNT]
@onready var raycast_0 : RayCast3D = $"../path_npc_0/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_1 : RayCast3D #= $"../Path3D/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
var raycast = [NPC_COUNT]
@onready var npc_0 : Node3D = $"../path_npc_0/PathFollow3D/MeshInstance3D/StaticBody3D/Npc"
var anim_0_walk : AnimationPlayer
var anim_0_idle : AnimationPlayer
var anim_0_shovel : AnimationPlayer
var bock_bar = [NPC_COUNT]

# snowmen
var snowmen_activated = false
@onready var snowman_0 : Node3D = $"../path_snowman_0/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
@onready var snowman_1 : Node3D = $"../path_snowman_1/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
@onready var snowman_2 : Node3D = $"../path_snowman_2/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
var anim_snowman_0_start: AnimationPlayer
var anim_snowman_0_chase : AnimationPlayer
var anim_snowman_1_start : AnimationPlayer
var anim_snowman_1_chase : AnimationPlayer
var anim_snowman_2_start : AnimationPlayer
var anim_snowman_2_chase : AnimationPlayer
@onready var raycast_snowman_0 : RayCast3D = $"../path_snowman_0/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_snowman_1 : RayCast3D = $"../path_snowman_1/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_snowman_2 : RayCast3D = $"../path_snowman_2/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var path_follow_snowman_0 : PathFollow3D = $"../path_snowman_0/PathFollow3D"
@onready var path_follow_snowman_1 : PathFollow3D = $"../path_snowman_1/PathFollow3D"
@onready var path_follow_snowman_2 : PathFollow3D = $"../path_snowman_2/PathFollow3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow_0.loop = false
	#path_follow_1.loop = false
	path_follow_snowman_0.loop = false
	path_follow_snowman_1.loop = false
	path_follow_snowman_2.loop = false
	movement_speed[0] = movement_speed_0
	#movement_speed[1] = movement_speed_1
	is_moving[0] = is_moving_0
	#is_moving[1] = is_moving_1
	path_follow[0] = path_follow_0
	#path_follow[1] = path_follow_1
	raycast[0] = raycast_0
	#raycast[1] = raycast_1
	anim_0_idle = npc_0.get_child(0).get_child(1)
	anim_0_walk = npc_0.get_child(0).get_child(2)
	anim_0_shovel = npc_0.get_child(0).get_child(3)
	bock_bar[0] = npc_0.get_child(1)
	bock_bar[0].value = 100	
	snowman_0.hide()
	snowman_1.hide()
	snowman_2.hide()
	anim_snowman_0_start = snowman_0.get_child(0).get_child(2)
	anim_snowman_0_chase = snowman_0.get_child(0).get_child(3)
	anim_snowman_1_start = snowman_1.get_child(0).get_child(2)
	anim_snowman_1_chase = snowman_1.get_child(0).get_child(3)
	anim_snowman_2_start = snowman_2.get_child(0).get_child(2)
	anim_snowman_2_chase = snowman_2.get_child(0).get_child(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move npc #0
	_move_npc(delta, 0) #is_moving_0, path_follow_0, movement_speed_0)
	_check_collision(0) #raycast_0, is_moving_0)
	_update_bock_bar(delta, 0)
	_move_snowmen(delta)
	# move npc #1
	#_move_npc(delta, is_moving_1 ,path_follow_1, movement_speed_1)
	#_check_collision(raycast_1, is_moving_1)
	
	
func _move_snowmen(delta: float):
	if (snowmen_activated):
		snowman_0.show()
		path_follow_snowman_0.progress += delta * MOVEMENT_SPEED * 1.5
		snowman_1.show()
		path_follow_snowman_1.progress += delta * MOVEMENT_SPEED * 1.5
		snowman_2.show()
		path_follow_snowman_2.progress += delta * MOVEMENT_SPEED * 1.5
		
		if (path_follow_snowman_0.progress_ratio == 1
		 && path_follow_snowman_1.progress_ratio == 1
		 && path_follow_snowman_2.progress_ratio == 1):
			await get_tree().create_timer(3).timeout
			snowmen_activated = false
			path_follow_snowman_0.progress = 0
			snowman_0.hide()
			await get_tree().create_timer(0.07).timeout
			path_follow_snowman_1.progress = 0
			snowman_1.hide()
			await get_tree().create_timer(0.07).timeout
			path_follow_snowman_2.progress = 0
			snowman_2.hide()

func _check_collision(num: int) -> void:
	# npc shovel
	if raycast[num].is_colliding() and is_moving[num]:
			is_moving[num] = false
			var col = raycast[num].get_collider()
			if col:
				movement_speed[num] = 0
				await get_tree().create_timer(2.0).timeout
				col.get_owner().queue_free()
				movement_speed[num] = 0
			is_moving[num] = true
			movement_speed[num] = MOVEMENT_SPEED
			
	# snowman trigger
	if raycast_snowman_0.is_colliding():
		bock_bar[0].value = 0
	if raycast_snowman_1.is_colliding():
		bock_bar[1].value = 0
	if raycast_snowman_2.is_colliding():
		bock_bar[2].value = 0
	
			

func _update_bock_bar(delta: float, num: int) -> void:
	if bock_bar[num].value == 0:
		# walk home
		if anim_0_shovel.is_playing():
			anim_0_shovel.stop()
		if !anim_0_walk.is_playing():
			anim_0_walk.play("Walkcycle")
		movement_speed[num] = -1.5 * MOVEMENT_SPEED
		if (path_follow[num].progress == 0.0) and is_moving[num]:
			if anim_0_walk.is_playing():
				anim_0_walk.stop()
			if !anim_0_idle.is_playing():
				anim_0_idle.play("Idle")
			#regenerate bock
			is_moving[num] = false
			await get_tree().create_timer(5.0).timeout
			path_follow[num].progress = 0.1
			bock_bar[num].value = 100
			is_moving[num] = true	
			movement_speed[num] = MOVEMENT_SPEED
	else:
		bock_bar[num].value += delta * BOCK_COST
		
func _move_npc(delta: float, num: int) -> void:
	# TODO make anim an array for each NPC
	path_follow[num].progress += delta * movement_speed[num]
	if (path_follow[num].progress == 0):
		if is_moving[num]:
			if !anim_0_walk.is_playing():
				anim_0_walk.play("Walkcycle")
		else: 
			if anim_0_walk.is_playing():
				anim_0_walk.stop()
			if !anim_0_idle.is_playing():
				anim_0_idle.play("Idle")
	else:
		if is_moving[num]:
			if !anim_0_walk.is_playing():
				anim_0_walk.play("Walkcycle")
		else:
			if anim_0_walk.is_playing():
				anim_0_walk.stop()
			if !anim_0_shovel.is_playing():
				anim_0_shovel.play("Shovel")
