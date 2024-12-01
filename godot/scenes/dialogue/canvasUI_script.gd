extends CanvasLayer

@onready var dialogue_window: Control = $DialogueWindow
@onready var miku: Sprite2D = $Miku
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FrauHollePortrait = preload("res://assets/sprites/KarenHolle.png")
const DulliPortrait = preload("res://assets/sprites/Dulli.png")
const FrostyPortrait = preload("res://assets/sprites/Frosty.png")


var Blue
var Red
var Teal
var OutlineColor
var BlueBackground
var RedBackground
var TealBackground
var BackgroundColor
var LastDialogueID
var IsCutIn

func SetPortrait(PortraitID):
	match PortraitID:
		-1:
			miku.material.set_shader_parameter("CutInValue", 0)
			CutOutCharacter()
		0:
			miku.set_texture(FrauHollePortrait)
			miku.material.set_shader_parameter("OutlineColor", Blue)
			miku.material.set_shader_parameter("BackgroundColor", BlueBackground)
		1:
			miku.set_texture(FrostyPortrait)
			miku.material.set_shader_parameter("OutlineColor", Teal)
			miku.material.set_shader_parameter("BackgroundColor", TealBackground)
		2:
			miku.set_texture(DulliPortrait)
			miku.material.set_shader_parameter("OutlineColor", Red)
			miku.material.set_shader_parameter("BackgroundColor", RedBackground)


func CutInCharacter():
	if !IsCutIn:
		IsCutIn = true
		animation_player.play("CutIn")

func CutOutCharacter():
	if IsCutIn:
		IsCutIn = false
		animation_player.play("CutOut")

	
func UpdateDialogueWindow(DialogueID):
	dialogue_window.UpdateDialogueWindow(DialogueID)
	
func RemoveDialogueWindow():
	dialogue_window.RemoveDialogueWindow()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Blue = miku.material.get_shader_parameter("Blue")
	Red = miku.material.get_shader_parameter("Red")
	Teal = miku.material.get_shader_parameter("Teal")
	OutlineColor = miku.material.get_shader_parameter("OutlineColor")
	BlueBackground = miku.material.get_shader_parameter("BlueBackground")
	RedBackground = miku.material.get_shader_parameter("RedBackground")
	TealBackground = miku.material.get_shader_parameter("TealBackground")
	BackgroundColor = miku.material.get_shader_parameter("BackgroundColor")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
