extends CanvasLayer

@onready var dialogue_window: Control = $DialogueWindow
@onready var miku: Sprite2D = $Miku
@onready var emotion_sprite: Sprite2D = $EmotionSprite
@onready var emotion_animations: AnimationPlayer = $EmotionAnimations
@onready var portrait_animations: AnimationPlayer = $PortraitAnimationPlayer
@onready var AudioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var IntroPlayer: AudioStreamPlayer = $IntroMusic

const FrauHollePortrait = preload("res://assets/sprites/KarenHolle.png")
const DulliPortrait = preload("res://assets/sprites/Dulli.png")
const FrostyPortrait = preload("res://assets/sprites/Frosty.png")
const EMOTION_ALERT = preload("res://assets/sprites/emotion_alert.png")
const EMOTION_ANGRY = preload("res://assets/sprites/emotion_angry.png")

const IntroSong = preload("res://music/Mad Holle_Intro Musik_01.wav")
const GameMusic = preload("res://music/Mad Holle_game musik_01.wav")
const RecordScratch = preload("res://music/Scratch.wav")
const CutInZingHolle = preload("res://music/Zing_Frau Holle.wav")
const CutOutZing = preload("res://music/Zzzzing Out 02.wav")
const AngryEmotionSound = preload("res://music/Angry Emotion.wav")
const AlertEmotionSound = preload("res://music/Alert_emotion_bounce_01.wav")

var Blue
var Red
var Teal
var OutlineColor
var BlueBackground
var RedBackground
var TealBackground
var BackgroundColor = 0
var DialogueID = 0
var LastDialogueID
var IsCutIn = false
var DIALOGUETEXTS = DialogueTexts
@onready var EVENTBUS = $"../EventBus"

func SetPortrait(DialogueID):
	var PortraitID = DialogueTexts.DialogueOptions[DialogueID][2]
	match PortraitID:
		-1:
			miku.material.set_shader_parameter("CutInValue", 0)
			CutOutCharacter()
			#print("WTF Portrait -1")
		0:
			miku.set_texture(FrauHollePortrait)
			CutInCharacter()
			miku.material.set_shader_parameter("OutlineColor", Blue)
			miku.material.set_shader_parameter("BackgroundColor", BlueBackground)
			#print("WTF Portrait 0")
		1:
			miku.set_texture(FrostyPortrait)
			CutInCharacter()
			miku.material.set_shader_parameter("OutlineColor", Teal)
			miku.material.set_shader_parameter("BackgroundColor", TealBackground)
			#print("WTF Portrait 1")
		2:
			miku.set_texture(DulliPortrait)
			CutInCharacter()
			miku.material.set_shader_parameter("OutlineColor", Red)
			miku.material.set_shader_parameter("BackgroundColor", RedBackground)
			#print("WTF Portrait 2")

func SetEmotion(DialogueID):
	var EmotionID = DialogueTexts.DialogueOptions[DialogueID][3]
	match EmotionID:
		-1:
			pass
		0:
			emotion_sprite.set_texture(EMOTION_ALERT)
			AudioPlayer.set_stream(AlertEmotionSound)
			AudioPlayer.play(0)
			emotion_animations.play("RESET")
			emotion_animations.play("EmotionAction")
		1:
			emotion_sprite.set_texture(EMOTION_ANGRY)
			AudioPlayer.set_stream(AngryEmotionSound)
			AudioPlayer.play(0)
			emotion_animations.play("RESET")
			emotion_animations.play("EmotionAction")

func CutInCharacter():
	if !IsCutIn:
		IsCutIn = true
		AudioPlayer.set_stream(CutOutZing)
		AudioPlayer.play(0)
		portrait_animations.play("CutIn")

func CutOutCharacter():
	if IsCutIn:
		IsCutIn = false
		AudioPlayer.set_stream(CutOutZing)
		AudioPlayer.play(0)
		portrait_animations.play("CutOut")

	
func UpdateDialogueWindow(DialogueID):
	SetPortrait(DialogueID)
	SetEmotion(DialogueID)
	dialogue_window.UpdateDialogueWindow(DialogueID)
	
func RemoveDialogueWindow():
	dialogue_window.RemoveDialogueWindow()

func PlayIntro():
	if !IntroPlayer.playing:
		IntroPlayer.set_stream(IntroSong)
		IntroPlayer.play(0)
		
	if DialogueID < 8:
		UpdateDialogueWindow(DialogueID)
		DialogueID += 1
		print(DialogueID)
	elif DialogueID <9:
		UpdateDialogueWindow(DialogueID)
		IntroPlayer.stop()
		AudioPlayer.set_stream(RecordScratch)
		AudioPlayer.play(0)
		DialogueID += 1
		print(DialogueID)
	elif DialogueID == 9:
		IntroPlayer.set_stream(GameMusic)
		IntroPlayer.play(0)
		CutOutCharacter()
		RemoveDialogueWindow()
		EVENTBUS.game_started = true
		DialogueID += 1
	

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
