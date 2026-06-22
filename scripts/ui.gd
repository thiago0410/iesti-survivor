extends CanvasLayer 

# Referências aos elementos visuais do HUD
@onready var barra_vida = $HUD/BarraVida 
@onready var texto_score = $HUD/TextoScore 
@onready var texto_nivel = $HUD/TextoNivel 
@onready var texto_vida_num = $HUD/BarraVida/numVida

# Referências aos elementos da tela de fim de jogo
@onready var tela_fim_jogo = $TelaFimJogo 
@onready var texto_mensagem = $TelaFimJogo/QuadroResultado/VBoxContainer/TextoMensagem
@onready var texto_score_final = $TelaFimJogo/QuadroResultado/VBoxContainer/TextoScoreFinal
@onready var botao_reiniciar = $TelaFimJogo/QuadroResultado/VBoxContainer/BotaoReiniciar

func _ready():
	# Força a interface a começar limpa e oculta a tela de fim de jogo
	tela_fim_jogo.visible = false 
	
	# Conecta o clique do botão de reiniciar à função correspondente
	if botao_reiniciar:
		botao_reiniciar.pressed.connect(_on_botao_reiniciar_pressed)
	
	# Busca os nós reais da fase para capturar os dados iniciais exatos
	var gm = get_tree().current_scene.get_node_or_null("GameManager") 
	var jogador = get_tree().current_scene.get_node_or_null("player") 
	
	# Se encontrar o jogador, define o tamanho máximo da barra de vida e o valor atual
	if jogador:
		barra_vida.max_value = jogador.vida_maxima 
		atualizar_vida(jogador.vida_atual) 
	else:
		atualizar_vida(5) 
		
	# Se encontrar o GameManager, pega os pontos iniciais (0) e nível (1) [cite: 1, 2]
	if gm:
		atualizar_score(gm.score) 
		atualizar_nivel(gm.nivel_atual) 
	else:
		atualizar_score(0) 
		atualizar_nivel(1) 

func atualizar_vida(nova_vida: int):
	var vida_segura = max(0, nova_vida)
	barra_vida.value = vida_segura
	var vida_inteira = int(vida_segura)
	var max_inteiro = int(barra_vida.max_value)
	texto_vida_num.text = str(vida_inteira) + " / " + str(max_inteiro)

func atualizar_score(novo_score: int):
	texto_score.text = "Score: " + str(novo_score) 

func atualizar_nivel(novo_nivel: int):
	texto_nivel.text = "Nível: " + str(novo_nivel) 

# 🟢 ATUALIZADO: Agora gerencia e preenche o quadro completo de fim de jogo
func mostrar_fim_de_jogo(mensagem: String, cor: Color):
	tela_fim_jogo.visible = true 
	
	# Define a mensagem principal (Vitória ou Derrota)
	texto_mensagem.text = mensagem 
	texto_mensagem.modulate = cor 
	
	# Busca o score final do GameManager para exibir dentro do quadro
	var gm = get_tree().current_scene.get_node_or_null("GameManager")
	var pontos_finais = 0
	if gm:
		pontos_finais = gm.score
		
	texto_score_final.text = "Score Atingido: " + str(pontos_finais)

# 🟢 NOVA FUNÇÃO: Reseta o jogo quando clica em "Jogar Novamente"
func _on_botao_reiniciar_pressed():
	get_tree().paused = false # IMPORTANTE: Retira a pausa, senão o jogo recomeça congelado!
	get_tree().reload_current_scene() # Recarrega a Fase 1 do zero de forma limpa
