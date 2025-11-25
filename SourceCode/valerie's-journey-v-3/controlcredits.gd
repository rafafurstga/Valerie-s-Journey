extends Control

# --- Variáveis de Configuração ---

# As frases que serão exibidas, uma por uma.
const PHRASES: PackedStringArray = [
	"Você pegou o MacGuffin"
]

@onready var som = $text_bip

# Tempo que o jogo espera entre a exibição de cada caractere (0.05s é um bom ritmo).
const CHAR_DELAY: float = 0.08
# Tempo em segundos que a frase completa fica na tela antes de passar para a próxima.
const PHRASE_DISPLAY_DURATION: float = 2.5

# --- Variáveis de Estado ---

var current_phrase_index: int = 0
var char_index: int = 0
var time_since_last_char: float = 0.0 # Tempo decorrido para o efeito de digitação.
var is_displaying: bool = true # Controla se estamos no meio da cutscene.

# --- Referências aos Nós ---
# OBS: Verifique se o caminho do nó está correto!
@onready var text_label: Label = $ColorRect/Label

# --- Funções do Godot ---

func _ready() -> void:
	# Garante que a Label comece vazia e que o processamento comece.
	text_label.text = ""
	# Inicia a cutscene exibindo a primeira frase.
	start_phrase()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		end_cutscene()
	if not is_displaying:
		return # Para o _process() se a cutscene terminou.
	
	# 1. Acumula o tempo para o efeito de digitação.
	time_since_last_char += delta
	
	# Se ainda estamos digitando (char_index não alcançou o tamanho da frase)...
	if char_index < text_label.text.length():
		if time_since_last_char >= CHAR_DELAY:
			time_since_last_char = 0.0 # Reseta o tempo
			som.play()
			char_index += 1
			
			# Torna o próximo conjunto de caracteres visível.
			text_label.visible_characters = char_index 
			
			# Se a digitação terminou nesta etapa
			if char_index >= text_label.text.length():
				# Inicia a espera antes de passar para a próxima frase.
				wait_and_proceed_to_next_phrase()
	
# --- Lógica da Cutscene ---

# Prepara e inicia a exibição da frase atual.
func start_phrase() -> void:
	if current_phrase_index >= PHRASES.size():
		# Todas as frases foram exibidas.
		end_cutscene()
		return

	# 1. Resetar variáveis de estado.
	char_index = 0
	time_since_last_char = 0.0
	
	# 2. *Chave da Correção:* Coloca o texto completo no Label 
	# (para que a quebra de linha seja calculada) e define 
	# que NENHUM caractere está visível.
	text_label.text = PHRASES[current_phrase_index]
	text_label.visible_characters = 0 # Torna todos invisíveis.
	
	# 3. Retorna o controle para o _process para iniciar a digitação.

# Espera o tempo definido e avança para a próxima frase ou encerra.
func wait_and_proceed_to_next_phrase():
	# Isso espera 3.0 segundos após a frase estar completa.
	await get_tree().create_timer(PHRASE_DISPLAY_DURATION).timeout
	
	# Limpa a tela antes de iniciar a próxima frase.
	text_label.text = "" 
	current_phrase_index += 1
	
	start_phrase() # Tenta iniciar a próxima frase.

func end_cutscene() -> void:
	get_tree().quit()
