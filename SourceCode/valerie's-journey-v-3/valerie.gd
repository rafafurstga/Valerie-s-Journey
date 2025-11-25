class_name Valerie
extends CharacterBody2D

signal modo_alterado(novo_modo_red: bool)

@onready var sprite = $Anime_Val
@onready var sprite_red = $Anime_ValRed
@onready var sprite_blue = $Anime_Val

@onready var fundo_normal = $Background1
@onready var fundo_red = $BackgroundRed

@onready var sfx_pulo = $SfxPulo
@onready var sfx_dash = $SfxDash

@export var SPEED = 300
@export var JUMP_VELOCITY = -500 
@export var GRAVITY = 1200
@export var MAXJUMPS = 1

# Dash
@export var DASH_SPEED = 800
@export var DASH_TIME = 0.15
@export var DASH_COOLDOWN = 0.5

var Red = false
var jumps_remaining = 0
var is_dashing = false
var can_dash = true

func _ready():
	fundo_normal.visible = not Red
	fundo_red.visible = Red

func _physics_process(delta):
	# Escolhe o sprite de acordo com o modo
	if Red:
		sprite = sprite_red
	else:
		sprite = sprite_blue

	sprite_blue.visible = not Red
	sprite_red.visible = Red

	# Gravidade e reset de pulo
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif is_on_floor():
		jumps_remaining = MAXJUMPS

	# DASH
	if Input.is_action_just_pressed("Dash") and not is_dashing and can_dash:
		start_dash()
		return  # impede o movimento normal durante o dash

	# Pulo normal
	if Input.is_action_just_pressed("Jump") and jumps_remaining > 0 and is_on_floor():
		sfx_pulo.play()
		velocity.y = JUMP_VELOCITY
		jumps_remaining -= 1

	# Movimento horizontal
	var direction = Input.get_axis("WalkLeft", "WalkRight")
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# Movimento normal só se não estiver dashando
	if not is_dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Troca de modo
	if Input.is_action_just_pressed("Modo"):
		Red = !Red
		emit_signal("modo_alterado", Red)
		fundo_normal.visible = not Red
		fundo_red.visible = Red

	# Animações e movimento final
	anima_update()
	move_and_slide()

func anima_update():
	var anim_new = "" 
	if is_on_floor():
		if velocity.x == 0:
			anim_new = "Idle"
		else:
			anim_new = "run"
	else:
		anim_new = "jump"

	if sprite.animation != anim_new:
		sprite.play(anim_new)

# Função de dash
func start_dash():
	is_dashing = true
	can_dash = false
	
	sfx_dash.play()
	var direction = 1 if not sprite.flip_h else -1
	var dash_target_x = global_position.x + direction * DASH_SPEED * DASH_TIME

	var tween = create_tween()
	tween.tween_property(self, "global_position:x", dash_target_x, DASH_TIME)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "_on_dash_finished"))

# Finalização do dash
func _on_dash_finished():
	is_dashing = false
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true
