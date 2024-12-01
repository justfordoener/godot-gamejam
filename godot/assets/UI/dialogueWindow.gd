extends Control

@onready var dialogue_box: NinePatchRect = $DialogueBox
@onready var name_box: NinePatchRect = $NameBox
@onready var dialogue_text: RichTextLabel = $DialogueBox/DialogueText
@onready var name_text: RichTextLabel = $NameBox/NameText
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var DIALOGUETEXTS = DialogueTexts
var IsDialogueVisible = false

func UpdateDialogueWindow(DialogueID):
	var NameText = DialogueTexts.DialogueOptions[DialogueID][0]
	var DialogueText = DialogueTexts.DialogueOptions[DialogueID][1]
	
	print(NameText.length())
	
	if NameText.length() == 0:
		name_box.visible = false
		print("INVISIBLE")
	else:
		name_box.visible = true
		name_text.clear()
		name_text.append_text(NameText)
		
	dialogue_text.clear()
	dialogue_text.append_text(DialogueText)
	if !IsDialogueVisible:
		IsDialogueVisible = true
		animation_player.play("SpawnWindow")
	else:
		animation_player.play("ContinueDialogue")
	pass

func RemoveDialogueWindow():
	IsDialogueVisible = false
	animation_player.play("RemoveWindow")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var TextSize = name_text.get_size()
	name_box.set_size(Vector2(TextSize.x + 10, 25))
	
	pass
