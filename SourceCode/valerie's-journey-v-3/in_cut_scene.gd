extends Control


const PHRASES: PackedStringArray = [
	"Não se esqueça do que fizeram contigo",
	"Não se esqueça do que fizeram com seu Reino, seu lar",
	"Não desista.",
	"Acorde e ache o MacGuffin",
    "Acorde, Valerie"
]

@onready var som = $text_bip

const CHAR_DELAY: float = 0.08
const PHRASE_DISPLAY_DURATION: float = 2.5
const NEXT_SCENE_PATH: String = "res://jogo.tscn"

var current_phrase_index: int = 0
var char_index: int = 0
var time_since_last_char: float = 0.0
var is_displaying: bool = true


@onready var text_label: Label = $ColorRect/Label

func _ready() -> void:
	text_label.text = ""
	start_phrase()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		end_cutscene()
	if not is_displaying:
		return
	
	time_since_last_char += delta
	
	if char_index < text_label.text.length():
		if time_since_last_char >= CHAR_DELAY:
			time_since_last_char = 0.0
			som.play()
			char_index += 1
			
			text_label.visible_characters = char_index 
			
			if char_index >= text_label.text.length():
				wait_and_proceed_to_next_phrase()
	
func start_phrase() -> void:
	if current_phrase_index >= PHRASES.size():
		end_cutscene()
		return

	char_index = 0
	time_since_last_char = 0.0
	

	text_label.text = PHRASES[current_phrase_index]
	text_label.visible_characters = 0

func wait_and_proceed_to_next_phrase():
	await get_tree().create_timer(PHRASE_DISPLAY_DURATION).timeout
	text_label.text = "" 
	current_phrase_index += 1
	
	start_phrase()

func end_cutscene() -> void:
	is_displaying = false
	
	await get_tree().create_timer(1.0).timeout
	
	if ResourceLoader.exists(NEXT_SCENE_PATH):
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
	else:
		print("ERRO: Cena principal não encontrada no caminho: ", NEXT_SCENE_PATH)
