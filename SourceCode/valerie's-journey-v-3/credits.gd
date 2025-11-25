extends Control

const MENU_SCENE = "res://MenuPrincipal.tscn"

@onready var anim_player = $AnimationPlayer
@onready var music_player = $MusicPlayer

func _ready() -> void:
	music_player.play()
	anim_player.play("rolar_creditos")
	anim_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		voltar_ao_menu()

func _on_animation_finished(anim_name: String):
	voltar_ao_menu()

func voltar_ao_menu():
	var tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -80, 1.0)
	await tween.finished
	
	if ResourceLoader.exists(MENU_SCENE):
		get_tree().change_scene_to_file(MENU_SCENE)
	else:
		print("Fim dos créditos! (Cena do menu não definida)")
		get_tree().quit()
