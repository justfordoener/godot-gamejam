extends Node

#const INTRO_TEXT_01_DE = "6:00 AM, Hoher Meißner 12b, 37290 Nimmerland. ... bzw. Hessen"
#const INTRO_TEXT_02_DE = "Gar kein Bock. Man, ey! Gar. Kein. Bock!"
#const INTRO_TEXT_03_DE = "Früher war echt alles besser! Kinder da, die die Betten aufschütteln, Brot ausm Ofen ziehn, Äpfel aufräumen, ..."
#const INTRO_TEXT_04_DE = "Warum so wenig Kinder heutzutage mehr in Brunnen fallen. Überhaupt, die Jugend!!"
#const INTRO_TEXT_05_DE = "Da konnt man den Kindern noch was beibringen! Und all die freie Arbeitskraft!"
#const INTRO_TEXT_06_DE = "Boa, nee, man. Alles [wave]snowed-in!![/wave] Voll kacke, ey. Gar kein Bock das alles freizuschaufeln damit wir fahren können..."
#const INTRO_TEXT_07_DE = "Was zum fick hören meine Ohren da???"
#const INTRO_TEXT_08_DE = "Ihr fahrt nirgends hin! Euer Tag ist hiermit gelaufen!!"
#const INTRO_TEXT_09_DE = "Schneeschaufeln?! Mein natürlicher Freind! Wartet nur, wo der Schnee herkommt gibts noch mehr!!"
#const INTRO_TEXT_10_DE = "Nehmt das!"
#const INTRO_TEXT_11_DE = "Sag ich doch. Einfach nicht mehr wie früher, gleich aufgeben. Wissen einfach nicht mehr was richtige Arbeit ist!"
#const INTRO_TEXT_12_DE = "Oha! Jetzt aber! Dann muss ich wohl härtere Geschütze auffahren!"
#const INTRO_TEXT_13_DE = "Okay, ihr wollt Ernst? Ihr kriegt Ernst! Ich zeig euch was diese alten Knochen noch können!"

var INTRO_TEXT_01 = tr("INTRO_01")
var INTRO_TEXT_02 = tr("INTRO_02")
var INTRO_TEXT_03 = tr("INTRO_03")
var INTRO_TEXT_04 = tr("INTRO_04")
var INTRO_TEXT_05 = tr("INTRO_05")
var INTRO_TEXT_06 = tr("INTRO_06")
var INTRO_TEXT_07 = tr("INTRO_07")
var INTRO_TEXT_08 = tr("INTRO_08")
var INTRO_TEXT_09 = tr("INTRO_09")
var INTRO_TEXT_10 = tr("INTRO_10")
var INTRO_TEXT_11 = tr("INTRO_11")
var INTRO_TEXT_12 = tr("INTRO_12")
var INTRO_TEXT_13 = tr("INTRO_13")


var DialogueOptions = { 
						0:["", INTRO_TEXT_01, -1],
						1:["Karen Holle", INTRO_TEXT_02, 0],
						2:["Karen Holle", INTRO_TEXT_03, 0],
						3:["Karen Holle", INTRO_TEXT_04, 0],
						4:["Karen Holle", INTRO_TEXT_05, 0],
						5:["Karen Holle", INTRO_TEXT_06, 0],
						6:["Karen Holle", INTRO_TEXT_07, 0],
						7:["Karen Holle", INTRO_TEXT_08, 0],
						8:["Karen Holle", INTRO_TEXT_09, 0],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
