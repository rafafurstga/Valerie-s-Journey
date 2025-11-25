extends Node

@onready var musica_normal = $MusicaAzul
@onready var musica_red = $MusicaRed

func _ready():
	musica_normal.play()
	musica_red.play()
	
	musica_normal.volume_db = 0
	musica_red.volume_db = -80

func trocar_musica(red_ativo: bool):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	if red_ativo:
		tween.tween_property(musica_normal, "volume_db", -80, 0)
		tween.tween_property(musica_red, "volume_db", 0, 0)
	else:
		tween.tween_property(musica_normal, "volume_db", 0, 0)
		tween.tween_property(musica_red, "volume_db", -80, 0)

func pausar_para_jingle():
	musica_normal.stream_paused = true
	musica_red.stream_paused = true

func retomar_musica():
	musica_normal.stream_paused = false
	musica_red.stream_paused = false
