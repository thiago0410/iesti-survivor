extends CanvasLayer

# Referências aos elementos visuais do HUD
@onready var barra_vida = $HUD/BarraVida
@onready var texto_score = $HUD/TextoScore
@onready var texto_nivel = $HUD/TextoNivel

# 🟢 NOVA REFERÊNCIA: Busca o texto numérico que colocamos dentro da barra
@onready var texto_vida_num = $HUD/BarraVida/numVida

# Referências aos elementos da tela de fim de jogo
@onready var tela_fim_jogo = $TelaFimJogo
@onready var texto_mensagem = $TelaFimJogo/TextoMensagem

func _ready():
	# Força a interface a começar limpa e oculta a tela de fim de jogo
	tela_fim_jogo.visible = false
	
	# Busca os nós reais da fase para capturar os dados iniciais exatos
	var gm = get_tree().current_scene.get_node_or_null("GameManager")
	var jogador = get_tree().current_scene.get_node_or_null("player")
	
	# Se encontrar o jogador, define o tamanho máximo da barra de vida e o valor atual
	if jogador:
		barra_vida.max_value = jogador.vida_maxima
		atualizar_vida(jogador.vida_atual)
	else:
		atualizar_vida(5)
		
	# Se encontrar o GameManager, pega os pontos iniciais (0) e nível (1)
	if gm:
		atualizar_score(gm.score)
		atualizar_nivel(gm.nivel_atual)
	else:
		atualizar_score(0)
		atualizar_nivel(1)

# 🟢 ATUALIZADO: Agora muda a barra gráfica E o texto ao mesmo tempo!
func atualizar_vida(nova_vida: int):
	# Garante que não mostre valores negativos se o dano for fatal
	var vida_segura = max(0, nova_vida)
	
	# Atualiza o preenchimento gráfico da barra
	barra_vida.value = vida_segura
	
	var vida_inteira = int(vida_segura)
	var max_inteiro = int(barra_vida.max_value)
	
	# Atualiza o texto numérico no formato "Vida Atual / Vida Máxima" (ex: 5 / 5)
	texto_vida_num.text = str(vida_segura) + " / " + str(max_inteiro)

func atualizar_score(novo_score: int):
	texto_score.text = "Score: " + str(novo_score)

func atualizar_nivel(novo_nivel: int):
	texto_nivel.text = "Nível: " + str(novo_nivel)

# Exibe a mensagem de fim de jogo (Vitória ou Derrota)
func mostrar_fim_de_jogo(mensagem: String, cor: Color):
	tela_fim_jogo.visible = true
	texto_mensagem.text = mensagem # (ou mensagem)
	texto_mensagem.modulate = cor
