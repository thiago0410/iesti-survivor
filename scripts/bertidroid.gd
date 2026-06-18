extends CharacterBody2D

const SPEED = 70.0 # Um pouco mais lento que o minion básico
const DISTANCIA_PARADA = 300.0 # Distância em pixels onde ele para para mirar

var jogador_alvo: Node2D = null
var vida_maxima: int = 4 # Um pouco mais resistente que o minion
var vida_atual: int = vida_maxima

var cena_tiro = preload("res://scenes/bertidroid.tscn")
var esta_mirando: bool = false

@onready var timer_ataque = $AtaqueTimer
@onready var rastro_mira = $RastroMira

func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if !jogador_alvo: return
	
	var distancia = global_position.distance_to(jogador_alvo.global_position)
	var direcao = global_position.direction_to(jogador_alvo.global_position)
	
	# Se não estiver travado mirando e estiver longe do jogador, ele caminha
	if !esta_mirando and distancia > DISTANCIA_PARADA:
		velocity = direcao * SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO # Pára para focar no tiro
		
	# Atualiza o rastro de mira em tempo real se estiver no período de preparação
	if esta_mirando:
		rastro_mira.clear_points()
		rastro_mira.add_point(Vector2.ZERO) # Ponto inicial: o centro do inimigo
		# Ponto final: a posição local do jogador em relação ao inimigo
		rastro_mira.add_point(to_local(jogador_alvo.global_position))

func _on_ataque_timer_timeout():
	if !jogador_alvo: return
	
	# Começa a fase de mira (Rastro)
	esta_mirando = true
	
	# Aguarda 1 segundo com a linha vermelha na tela (Aviso prévio)
	await get_tree().create_timer(1.0).timeout
	
	# Apaga o rastro logo antes do disparo
	rastro_mira.clear_points()
	esta_mirando = false
	
	# Dispara o projétil de fato se o jogador ainda estiver vivo
	if jogador_alvo:
		var tiro = cena_tiro.instantiate()
		tiro.global_position = global_position
		tiro.direction = global_position.direction_to(jogador_alvo.global_position)
		get_tree().current_scene.add_child(tiro)

func receber_dano(quantidade: float):
	vida_atual -= quantidade
	if vida_atual <= 0:
		morrer()

func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("GameManager")
	if game_manager:
		game_manager.adicionar_score(2) # Atiradores dão mais pontos (2)
	queue_free()
