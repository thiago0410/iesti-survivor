extends Node2D

var cena_minion = preload("res://scenes/edminion.tscn") 
var cena_atirador = preload("res://scenes/bertidroid.tscn") 
var cena_mago = preload("res://scenes/joao_mago.tscn")

@onready var player = $"../player" 
@onready var timer = $spawnTimer 

# Buscaremos o GameManager para saber o nível atual em tempo real
@onready var game_manager = $"../gameManager"

func _ready():
	# 🟢 NÍVEL 1: Começa gerando 1 inimigo a cada 3.0 segundos
	timer.wait_time = 3.0 

func _process(_delta):
	# Mantido limpo para evitar a aceleração infinita [cite: 18, 19]
	pass

func _on_spawn_timer_timeout():
	if player == null: return 
	
	# Descobre o nível atual (se não achar o GameManager, assume nível 1 por segurança)
	var nivel = 1
	if game_manager:
		nivel = game_manager.nivel_atual
		
	var tipo_escolhido = cena_minion
	var sorteio = randf() # Gera um número aleatório entre 0.0 e 1.0
	
	# 🎯 SISTEMA DE PORCENTAGEM POR NÍVEL:
	if nivel == 1:
		# 100% Minion
		tipo_escolhido = cena_minion
		
	elif nivel == 2:
		# 60% Minion (0.0 até 0.6) e 40% Atirador (0.6 até 1.0)
		if sorteio <= 0.6:
			tipo_escolhido = cena_minion
		else:
			tipo_escolhido = cena_atirador
			
	elif nivel == 3:
		# 50% Minion (0.0 até 0.5), 30% Atirador (0.5 até 0.8) e 20% Mago (0.8 até 1.0)
		if sorteio <= 0.5:
			tipo_escolhido = cena_minion
		elif sorteio <= 0.8:
			tipo_escolhido = cena_atirador
		else:
			tipo_escolhido = cena_mago

	# Instancia o inimigo sorteado
	var inimigo = tipo_escolhido.instantiate() 
	
	# Define a posição ao redor do jogador
	var angulo_aleatorio = randf() * PI * 2 
	var raio_spawn = 500 
	var vetor_spawn = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * raio_spawn 
	
	inimigo.global_position = player.global_position + vetor_spawn 
	inimigo.definir_alvo(player) 
	get_tree().current_scene.add_child(inimigo) 

# ⏱️ CONTROLE DE VELOCIDADE DO SPAWN POR NÍVEL
func atualizar_dificuldade(nivel: int):
	if nivel == 2:
		print("Dificuldade aumentada: Fase 2!") 
		timer.wait_time = 1.8 # Janela de spawn diminui (Fica mais rápido) [cite: 20]
	elif nivel == 3:
		print("Dificuldade máxima: Fase 3!") 
		timer.wait_time = 1.2 # Ritmo final caótico
