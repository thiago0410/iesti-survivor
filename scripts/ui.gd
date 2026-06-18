extends CanvasLayer

# Referências aos elementos visuais do HUD
@onready var barra_vida = $HUD/BarraVida
@onready var texto_score = $HUD/TextoScore
@onready var texto_nivel = $HUD/TextoNivel

# Referências aos elementos da tela de fim de jogo
@onready var tela_fim_jogo = $TelaFimJogo
@onready var texto_mensagem = $TelaFimJogo/TextoMensagem

func _ready():
	# Configura o estado inicial visual
	atualizar_vida(5)
	atualizar_score(0)
	atualizar_nivel(1)
	tela_fim_jogo.visible = false

func atualizar_vida(nova_vida: int):
	barra_vida.value = nova_vida

func atualizar_score(novo_score: int):
	texto_score.text = "Score: " + str(novo_score)

func atualizar_nivel(novo_nivel: int):
	texto_nivel.text = "Nível: " + str(novo_nivel)

# Exibe a mensagem de fim de jogo (Vitória ou Derrota)
func mostrar_fim_de_jogo(mensagem: String, cor: Color):
	tela_fim_jogo.visible = true
	texto_mensagem.text = mensagem
	texto_mensagem.modulate = cor # Altera a cor do texto (ex: vermelho para derrota, verde para vitória)
