extends Control

const NEXT_SCENE_PATH: String = "res://InCutScene.tscn"

func _ready():
	visible = true

func _on_botao_start_pressed() -> void:
	if ResourceLoader.exists(NEXT_SCENE_PATH):
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
	else:
		print("ERRO: Cena principal não encontrada no caminho: ", NEXT_SCENE_PATH)

func _on_botao_sair_pressed():
	get_tree().quit()
	
