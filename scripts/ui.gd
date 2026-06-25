extends CanvasLayer 

@onready var barra_vida = $HUD/BarraVida 
@onready var texto_score = $HUD/TextoScore 
@onready var texto_nivel = $HUD/TextoNivel 
@onready var texto_vida_num = $HUD/BarraVida/numVida
@onready var tela_fim_jogo = $TelaFimJogo 
@onready var texto_mensagem = $TelaFimJogo/QuadroResultado/VBoxContainer/TextoMensagem
@onready var texto_score_final = $TelaFimJogo/QuadroResultado/VBoxContainer/TextoScoreFinal
@onready var botao_reiniciar = $TelaFimJogo/QuadroResultado/VBoxContainer/BotaoReiniciar

func _ready():
	tela_fim_jogo.visible = false 
	if botao_reiniciar:
		botao_reiniciar.pressed.connect(_on_botao_reiniciar_pressed)
	var gm = get_tree().current_scene.get_node_or_null("GameManager") 
	var jogador = get_tree().current_scene.get_node_or_null("player") 
	if jogador:
		barra_vida.max_value = jogador.vida_maxima 
		atualizar_vida(jogador.vida_atual) 
	else:
		atualizar_vida(5) 
	if gm:
		atualizar_score(gm.score) 
		atualizar_nivel(gm.nivel_atual) 
	else:
		atualizar_score(0) 
		atualizar_nivel(1) 

# atualiza a barra de vida
func atualizar_vida(nova_vida: int):
	var vida_segura = max(0, nova_vida)
	barra_vida.value = vida_segura
	var vida_inteira = int(vida_segura)
	var max_inteiro = int(barra_vida.max_value)
	texto_vida_num.text = str(vida_inteira) + " / " + str(max_inteiro)

# atualiza o contador de score
func atualizar_score(novo_score: int):
	texto_score.text = "Score: " + str(novo_score) 

# atualiza o contador de nivel
func atualizar_nivel(novo_nivel: int):
	texto_nivel.text = "Nível: " + str(novo_nivel) 

# tela de fim de jogo (tanto pra vitoria, quanto pra derrota)
func mostrar_fim_de_jogo(mensagem: String, cor: Color):
	tela_fim_jogo.visible = true 
	texto_mensagem.text = mensagem 
	texto_mensagem.modulate = cor 
	var gm = get_tree().current_scene.get_node_or_null("gameManager")
	var pontos_finais = 0
	if gm:
		pontos_finais = gm.score
	texto_score_final.text = "Score Atingido: " + str(pontos_finais)
	if cor == Color.RED:
		if has_node("MusicaDerrota"):
			$MusicaDerrota.play()
	else:
		if has_node("MusicaVitoria"):
			$MusicaVitoria.play()

# reinicia o jogo do zero
func _on_botao_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene() 

func atualizar_timer_powerup(segundos_restantes: float):
	var label_timer = get_node_or_null("%TextoTimerTiro")
	if label_timer:
		if segundos_restantes > 0.0:
			label_timer.text = "Tiro Rápido: %.1fs" % segundos_restantes
		else:
			label_timer.text = ""
