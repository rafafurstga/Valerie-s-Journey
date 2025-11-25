extends Node

# Sinal para avisar a UI que o número mudou
signal estrelas_mudaram(nova_quantidade)

var total_estrelas = 0

func adicionar_estrela():
	total_estrelas += 1
	# Avisa quem estiver ouvindo (a UI)
	estrelas_mudaram.emit(total_estrelas)
