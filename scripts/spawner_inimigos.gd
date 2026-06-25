extends Node2D

var cena_minion = preload("res://scenes/edminion.tscn") 
var cena_atirador = preload("res://scenes/bertidroid.tscn") 
var cena_mago = preload("res://scenes/joao_mago.tscn")
@onready var player = $"../player" 
@onready var timer = $spawnTimer 
@onready var game_manager = $"../gameManager"

func _ready():
	timer.wait_time = 3.0 

func _process(_delta):
	pass

# a cada x segundo, escolhe uma posicao aleatoria e um inimigo de acordo com o nivel para spawnar
func _on_spawn_timer_timeout():
	if player == null: return 
	var nivel = 1
	if game_manager:
		nivel = game_manager.nivel_atual
	var tipo_escolhido = cena_minion
	var sorteio = randf() 
	if nivel == 1: # 100% edminion
		tipo_escolhido = cena_minion
	elif nivel == 2: # 60% edminion 40% bertidroid
		if sorteio <= 0.6:
			tipo_escolhido = cena_minion
		else:
			tipo_escolhido = cena_atirador
	elif nivel == 3: # 50% edminion 30% bertidroid 20% joao mago
		if sorteio <= 0.5:
			tipo_escolhido = cena_minion
		elif sorteio <= 0.8:
			tipo_escolhido = cena_atirador
		else:
			tipo_escolhido = cena_mago
	var inimigo = tipo_escolhido.instantiate() 
	var angulo_aleatorio = randf() * PI * 2 
	var raio_spawn = 500 
	var vetor_spawn = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * raio_spawn 
	inimigo.global_position = player.global_position + vetor_spawn 
	inimigo.definir_alvo(player) 
	get_tree().current_scene.add_child(inimigo) 

# atualiza o tempo de spawn inimigo conforme o nivel
func atualizar_dificuldade(nivel: int):
	if nivel == 2:
		print("Dificuldade aumentada: Fase 2!") 
		timer.wait_time = 1.8 
	elif nivel == 3:
		print("Dificuldade máxima: Fase 3!") 
		timer.wait_time = 1.2 
