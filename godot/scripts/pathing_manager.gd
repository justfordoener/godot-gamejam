extends Node

@onready var grid_map : GridMap = $"../GridMap"
@onready var parent_node = $".."

var MOVEMENT_SPEED := 1
var NPC_COUNT := 3
var BOCK_COST := -5
var movement_speed_0 = MOVEMENT_SPEED
var movement_speed_1 = MOVEMENT_SPEED
var movement_speed_2 = MOVEMENT_SPEED
var movement_speed = [movement_speed_0, movement_speed_1, movement_speed_2]
var is_moving_0 = true
var is_moving_1 = true
var is_moving_2 = true
var game_started = false
var is_moving = [is_moving_0, is_moving_1, is_moving_2]
@onready var path_follow_0 : PathFollow3D = $"../path_npc_0/PathFollow3D"
@onready var path_follow_1 : PathFollow3D = $"../path_npc_1/PathFollow3D"
@onready var path_follow_2 : PathFollow3D = $"../path_npc_2/PathFollow3D"
@onready var path_follow = [path_follow_0, path_follow_1, path_follow_2]
@onready var raycast_0 : RayCast3D = $"../path_npc_0/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_1 : RayCast3D = $"../path_npc_1/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_2 : RayCast3D = $"../path_npc_2/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast = [raycast_0, raycast_1, raycast_2]
@onready var npc_0 : Node3D = $"../path_npc_0/PathFollow3D/MeshInstance3D/StaticBody3D/Npc"
@onready var npc_1 : Node3D = $"../path_npc_1/PathFollow3D/MeshInstance3D/StaticBody3D/Npc"
@onready var npc_2 : Node3D = $"../path_npc_2/PathFollow3D/MeshInstance3D/StaticBody3D/Npc"
@onready var npcs = [npc_0, npc_1, npc_2]
@onready var anim_0_idle : AnimationPlayer	 = npc_0.get_child(0).get_child(1)
@onready var anim_0_walk : AnimationPlayer	 = npc_0.get_child(0).get_child(2)
@onready var anim_0_shovel : AnimationPlayer = npc_0.get_child(0).get_child(3)
@onready var anim_0_run : AnimationPlayer = npc_0.get_child(0).get_child(4)
@onready var anim_1_idle : AnimationPlayer	 = npc_1.get_child(0).get_child(1)
@onready var anim_1_walk : AnimationPlayer	 = npc_1.get_child(0).get_child(2)
@onready var anim_1_shovel : AnimationPlayer = npc_1.get_child(0).get_child(3)
@onready var anim_1_run : AnimationPlayer = npc_1.get_child(0).get_child(4)
@onready var anim_2_idle : AnimationPlayer	 = npc_2.get_child(0).get_child(1)
@onready var anim_2_walk : AnimationPlayer	 = npc_2.get_child(0).get_child(2)
@onready var anim_2_shovel : AnimationPlayer = npc_2.get_child(0).get_child(3)
@onready var anim_2_run : AnimationPlayer = npc_2.get_child(0).get_child(4)
@onready var idle_anims = [anim_0_idle, anim_1_idle, anim_2_idle]
@onready var walk_anims = [anim_0_walk, anim_1_walk, anim_2_walk]
@onready var shovel_anims = [anim_0_shovel, anim_1_shovel, anim_2_shovel]
@onready var run_anims = [anim_0_run, anim_1_run, anim_2_run]
var bock_bar0 : ProgressBar
var bock_bar1 : ProgressBar
var bock_bar2 : ProgressBar
var bock_bar = [bock_bar0, bock_bar1, bock_bar2]
var npc_rotation_base : Basis = Basis(Vector3(0,1,0), PI)

# snowmen
var snowmen_activated = false
@onready var snowman_0 : Node3D = $"../path_snowman_0/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
@onready var snowman_1 : Node3D = $"../path_snowman_1/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
@onready var snowman_2 : Node3D = $"../path_snowman_2/PathFollow3D/MeshInstance3D/StaticBody3D/Snowman"
@onready var anim_snowman_0_start : AnimationPlayer
@onready var anim_snowman_0_chase : AnimationPlayer
@onready var anim_snowman_1_start : AnimationPlayer
@onready var anim_snowman_1_chase : AnimationPlayer
@onready var anim_snowman_2_start : AnimationPlayer
@onready var anim_snowman_2_chase : AnimationPlayer
@onready var raycast_snowman_0 : RayCast3D = $"../path_snowman_0/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_snowman_1 : RayCast3D = $"../path_snowman_1/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var raycast_snowman_2 : RayCast3D = $"../path_snowman_2/PathFollow3D/MeshInstance3D/StaticBody3D/RayCast3D"
@onready var path_follow_snowman_0 : PathFollow3D = $"../path_snowman_0/PathFollow3D"
@onready var path_follow_snowman_1 : PathFollow3D = $"../path_snowman_1/PathFollow3D"
@onready var path_follow_snowman_2 : PathFollow3D = $"../path_snowman_2/PathFollow3D"

#audio
@onready var music_player : AudioStreamPlayer = $"../AudioStreamPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow_0.loop = false
	path_follow_1.loop = false
	path_follow_2.loop = false
	path_follow_snowman_0.loop = false
	path_follow_snowman_1.loop = false
	path_follow_snowman_2.loop = false
	bock_bar[0] = npc_0.get_child(1)
	bock_bar[0].value = 100	
	bock_bar[1] = npc_1.get_child(1)
	bock_bar[1].value = 100	
	bock_bar[2] = npc_2.get_child(1)
	bock_bar[2].value = 100	
	snowman_0.hide()
	snowman_1.hide()
	snowman_2.hide()
	anim_snowman_0_start = snowman_0.get_child(0).get_child(2)
	anim_snowman_0_chase = snowman_0.get_child(0).get_child(3)
	anim_snowman_1_start = snowman_1.get_child(0).get_child(2)
	anim_snowman_1_chase = snowman_1.get_child(0).get_child(3)
	anim_snowman_2_start = snowman_2.get_child(0).get_child(2)
	anim_snowman_2_chase = snowman_2.get_child(0).get_child(3)

func _process(delta: float) -> void:
	
	if !game_started:
		pass
	
	# npc #0
	_move_npc(delta, 0)
	_check_collision(0) 
	_update_bock_bar(delta, 0)
	
	# npc #1
	_move_npc(delta, 1)
	_check_collision(1) 
	_update_bock_bar(delta, 1)
	
	# npc #2
	_move_npc(delta, 2)
	_check_collision(2) 
	_update_bock_bar(delta, 2)
	
	_move_snowmen(delta)

func _move_snowmen(delta: float):
	if (snowmen_activated):
		parent_node.ability_slider.material.set_shader_parameter("slider", 0.0)
		snowman_0.show()
		if !anim_snowman_0_start.is_playing():
			anim_snowman_0_start.play("Ready")
		if !anim_snowman_1_chase.is_playing():
			anim_snowman_1_chase.play("Angry_chase_baseballbat")
		if !anim_snowman_2_chase.is_playing():
			anim_snowman_2_chase.play("Angry_chase_morningstar")
		path_follow_snowman_0.progress += delta * MOVEMENT_SPEED * 1.5
		snowman_1.show()
		anim_snowman_1_chase.play()
		path_follow_snowman_1.progress += delta * MOVEMENT_SPEED * 1.5
		snowman_2.show()
		anim_snowman_2_chase.play()
		path_follow_snowman_2.progress += delta * MOVEMENT_SPEED * 1.5
		
		if (path_follow_snowman_0.progress_ratio == 1
		 && path_follow_snowman_1.progress_ratio == 1
		 && path_follow_snowman_2.progress_ratio == 1):
			await get_tree().create_timer(2).timeout
			snowmen_activated = false
			path_follow_snowman_0.progress = 0
			snowman_0.hide()
			await get_tree().create_timer(0.07).timeout
			path_follow_snowman_1.progress = 0
			snowman_1.hide()
			await get_tree().create_timer(0.07).timeout
			path_follow_snowman_2.progress = 0
			snowman_2.hide()
			parent_node.add_val = 0

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
	if raycast_snowman_0.is_colliding() and snowman_0.is_visible_in_tree():
		bock_bar[0].value = 0
	if raycast_snowman_1.is_colliding() and snowman_1.is_visible_in_tree():
		bock_bar[1].value = 0
	if raycast_snowman_2.is_colliding() and snowman_2.is_visible_in_tree():
		bock_bar[2].value = 0
	
			

func _update_bock_bar(delta: float, num: int) -> void:
	if bock_bar[num].value == 0:
		# walk home
		npcs[num].transform.basis = Basis()
		if shovel_anims[num].is_playing():
			shovel_anims[num].stop()
		if !run_anims[num].is_playing():
			run_anims[num].play("Crappy_Run")
		movement_speed[num] = -1.5 * MOVEMENT_SPEED
		if (path_follow[num].progress == 0.0) and is_moving[num]:
			if walk_anims[num].is_playing():
				walk_anims[num].stop()
			if !idle_anims[num].is_playing():
				idle_anims[num].play("Idle")
			#regenerate bock
			is_moving[num] = false
			await get_tree().create_timer(5.0).timeout
			path_follow[num].progress = 0.1
			npcs[num].transform.basis = npc_rotation_base
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
			if !walk_anims[num].is_playing():
				walk_anims[num].play("Walkcycle")
		else: 
			if walk_anims[num].is_playing():
				walk_anims[num].stop()
			if !idle_anims[num].is_playing():
				idle_anims[num].play("Idle")
	else:
		if is_moving[num]:
			if !walk_anims[num].is_playing():
				walk_anims[num].play("Walkcycle")
		else:
			if walk_anims[num].is_playing():
				walk_anims[num].stop()
			if !shovel_anims[num].is_playing():
				shovel_anims[num].play("Shovel")
