extends Node2D

var cena_minion = preload("res://scenes/edminion.tscn")
var cena_atirador = preload("res://scenes/bertidroid.tscn")

var inimigo_atual = cena_minion

@onready var player = $"../player"
@onready var timer = $spawnTimer

func _ready():
	# 🟢 CALIBRAÇÃO INICIAL (NÍVEL 1)
	# Começa gerando 1 inimigo a cada 3.0 segundos (ritmo calmo para começar)
	timer.wait_time = 5.0

func _process(_delta):
	# 🔴 REMOVEMOS A ACELERAÇÃO INFINITA DAQUI!
	# Deixar o _process vazio ou apagá-lo impede que o jogo saia de controle sozinho.
	pass

func _on_spawn_timer_timeout():
	if player == null: return
	
	var tipo_escolhido = inimigo_atual
	
	# Se estiver nas fases com atirador, mistura para não sobrecarregar
	if inimigo_atual == cena_atirador and randf() > 0.4:
		# 60% de chance de ser minion comum, 40% de ser atirador
		tipo_escolhido = cena_minion
		
	var inimigo = tipo_escolhido.instantiate()
	
	var angulo_aleatorio = randf() * PI * 2
	var raio_spawn = 500
	var vetor_spawn = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * raio_spawn
	
	inimigo.global_position = player.global_position + vetor_spawn
	inimigo.definir_alvo(player)
	get_tree().current_scene.add_child(inimigo)

# 🎯 CONTROLE RÍGIDO DE DIFICULDADE POR NÍVEL
# Agora os valores são fixos e testados para o jogador conseguir respirar!
func atualizar_dificuldade(nivel: int):
	if nivel == 2:
		print("Dificuldade aumentada: Fase 2!")
		# No nível 2, os inimigos surgem a cada 1.8 segundos e entra o atirador
		timer.wait_time = 1.8
		inimigo_atual = cena_atirador
	elif nivel == 3:
		print("Dificuldade máxima: Fase 3!")
		# No nível 3 (ritmo final), surge 1 monstro a cada 1.0 segundo
		timer.wait_time = 1.0
