extends Label

func _ready():
	Global.estrelas_mudaram.connect(atualizar_texto)
	text = str(Global.total_estrelas)

func atualizar_texto(novo_valor):
	text = str(novo_valor)
