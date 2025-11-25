extends Node2D

const NEXT_SCENE_PATH: String = "res://end.tscn"

@onready var fundo_normal = $Background1
@onready var fundo_red = $BackgroundRed
@onready var mapa_azul_scene := preload("res://Cenas/tile_map.tscn")
@onready var mapa_vermelho_scene := preload("res://Cenas/tile_map_2.tscn")
@onready var mapa_azul : TileMapLayer
@onready var mapa_vermelho : TileMapLayer
@onready var tutorial_label = $CanvasLayer/Tutorial1Label
@onready var music_manager = $MusicManager

func _ready() -> void:
	var player = get_tree().get_current_scene().get_node_or_null("Valerie")
	
	if player:
		player.connect("modo_alterado", Callable(self, "_on_valerie_modo_alterado"))
	else:
		push_warning("Valerie não encontrada na cena!")
			
	mapa_azul = mapa_azul_scene.instantiate()
	add_child(mapa_azul)
	mapa_azul.z_index = 1
	mapa_azul.visible = true
	
	print("Mapa azul adicionado:", mapa_azul)
	print("Posição do mapa:", mapa_azul.global_position)
	
	if music_manager:
		music_manager.trocar_musica(false)

func _process(delta: float) -> void:
	if Global.total_estrelas >= 3:
		end_main()

func end_main() -> void:
	if ResourceLoader.exists(NEXT_SCENE_PATH):
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
	else:
		print("ERRO: Cena principal não encontrada no caminho: ", NEXT_SCENE_PATH)
		
func _on_death_pit_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		get_tree().reload_current_scene()
		Global.total_estrelas = 0

func _on_valerie_modo_alterado(red_ativo: bool): 	
	alternar_mapa(red_ativo)
	
	if music_manager:
		music_manager.trocar_musica(red_ativo)
		
	if tutorial_label:
		tutorial_label.queue_free()
		tutorial_label = null
	
func adicionar_mapa_azul():
	mapa_azul = mapa_azul_scene.instantiate()
	add_child(mapa_azul)
	mapa_azul.visible = true
	
func adicionar_mapa_vermelho():
	mapa_vermelho = mapa_vermelho_scene.instantiate()
	add_child(mapa_vermelho)
	mapa_vermelho.visible = true
	
func remover_mapa_azul():
	if mapa_azul and mapa_azul.get_parent():
		mapa_azul.queue_free()
		mapa_azul = null
		
func remover_mapa_vermelho():
	if mapa_vermelho and mapa_vermelho.get_parent():
		mapa_vermelho.queue_free()
		mapa_vermelho = null
		
func alternar_mapa(red_ativo: bool):
	if red_ativo:
		if mapa_azul:
			mapa_azul.queue_free()
			mapa_azul = null
		if not mapa_vermelho:
			mapa_vermelho = mapa_vermelho_scene.instantiate()
			add_child(mapa_vermelho)
	else:
		if mapa_vermelho:
			mapa_vermelho.queue_free()
			mapa_vermelho = null
		if not mapa_azul:
			mapa_azul = mapa_azul_scene.instantiate()
			add_child(mapa_azul)
