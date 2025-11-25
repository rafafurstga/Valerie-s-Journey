extends Area2D

@onready var sprite = $EstrelaSprite
@onready var sfx_pega = $SfxPega

var music_manager = null

func _ready():
	music_manager = get_tree().get_first_node_in_group("MusicManager")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		if music_manager:
			music_manager.pausar_para_jingle()
		
		Global.adicionar_estrela()
		sfx_pega.play()
		
		sprite.visible = false
		set_deferred("monitoring", false)
		
		await sfx_pega.finished
		
		if music_manager:
			music_manager.retomar_musica()
			
		queue_free()
