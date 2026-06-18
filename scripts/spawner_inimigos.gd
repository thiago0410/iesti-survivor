extends Node2D

# Carrega a cena do Minion para podermos cloná-lo
var cena_minion = preload("res://scenes/edminion.tscn")
var cena_atirador = preload("res://scenes/bertidroid.tscn")
@onready var player = $"../player" # Referência ao jogador na fase
@onready var timer = $spawnTimer

# Variáveis para controle de dificuldade progressiva
var tempo_decorrido: float = 0.0
var modificador_tempo: float = 1.0


var inimigo_atual = cena_minion

func _process(delta):
	# Dificuldade Temporal: Aumenta o modificador conforme o tempo passa
	tempo_decorrido += delta
	# A cada 30 segundos, diminui o tempo de espera do timer ligeiramente
	if timer.wait_time > 0.5:
		timer.wait_time = max(0.5, 2.0 - (tempo_decorrido * 0.01))

func _on_spawn_timer_timeout():
	if player == null: return
	
	var tipo_escolhido = inimigo_atual
	
	var inimigo = tipo_escolhido.instantiate()
	if inimigo_atual == cena_atirador and randf() > 0.6:
		# 60% minion comum, 40% atirador para misturar a horda
		tipo_escolhido = cena_minion
	
	# Faz o inimigo nascer em um círculo ao redor do jogador (fora da visão da tela)
	var angulo_aleatorio = randf() * PI * 2
	var raio_spawn = 800 # Distância segura para não brotar na cara do jogador
	var vetor_spawn = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * raio_spawn
	
	inimigo.global_position = player.global_position + vetor_spawn
	
	# Diz ao inimigo quem perseguir
	inimigo.definir_alvo(player)
	
	# Adiciona o inimigo na fase
	get_tree().current_scene.add_child(inimigo)

# Função chamada pelo GameManager quando o nível sobe
func atualizar_dificuldade(nivel: int):
	if nivel == 2:
		print("Dificuldade aumentada: Fase 2!")
		timer.wait_time = 1.0 # Spawna muito mais rápido
		inimigo_atual = cena_atirador
		# Aqui na Fase 2 você poderá carregar o segundo tipo de inimigo depois!
	elif nivel == 3:
		print("Dificuldade máxima: Fase 3!")
		timer.wait_time = 0.5 # Spawna o dobro de rápido
