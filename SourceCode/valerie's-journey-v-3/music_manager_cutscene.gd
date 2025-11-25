extends Node

# Referências aos players de áudio
@onready var som = $text_bip

func _ready():
	# Começa as duas músicas juntas para garantir sincronia
	musica_normal.play()
