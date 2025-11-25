extends Control

@onready var music_manager = get_tree().get_first_node_in_group("MusicManager")
const NEXT_SCENE_PATH: String = "res://menu.tscn"

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		alternar_pause()

func alternar_pause():
	var estado_pause = !get_tree().paused
	get_tree().paused = estado_pause
	visible = estado_pause

func _on_botao_continuar_pressed():
	alternar_pause()

func _on_botao_sair_pressed():
	if ResourceLoader.exists(NEXT_SCENE_PATH):
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
	else:
		print("ERRO: Cena principal não encontrada no caminho: ", NEXT_SCENE_PATH)
