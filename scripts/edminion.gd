extends CharacterBody2D

const SPEED = 100.0 # O inimigo deve ser mais lento que o jogador
var jogador_alvo: Node2D = null
@warning_ignore("narrowing_conversion")
var vida_maxima : int = 3.0
var vida_atual : int = vida_maxima

@onready var sprite = $Sprite2D

# 🟢 CARREGA OS POWER-UPS: Prepara as cenas para serem instanciadas no mapa
var item_vida = preload("res://scenes/power_ups/power_up_vida.tscn")
var item_tiro = preload("res://scenes/power_ups/power_up_tiro_rapido.tscn")

func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if jogador_alvo:
		var direction = global_position.direction_to(jogador_alvo.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		if jogador_alvo.global_position.x < global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
func receber_dano(quantidade: float):
	vida_atual -= quantidade
	print("Vida restante edminion: ", vida_atual)
	if vida_atual <= 0:
		morrer()
			
# 🟢 FUNÇÃO DE MORTE ATUALIZADA COM SISTEMA DE DROP PROGRESSIVO
func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("GameManager")
	if not game_manager:
		game_manager = get_tree().current_scene.get_node_or_null("gameManager")
		
	# Valores padrão caso o GameManager não seja encontrado
	var nivel = 1
	var chance_drop = 0.15 # 15% de chance base no Nível 1
	
	if game_manager:
		game_manager.adicionar_score(1)
		nivel = game_manager.nivel_atual
		
	# 🎯 ESCALONAMENTO DA CHANCE DE DROP CONFORME OS NÍVEIS
	if nivel == 1:
		chance_drop = 0.15 # 15% de chance de dropar algo no nível 1
	elif nivel == 2:
		chance_drop = 0.30 # 30% de chance de dropar algo no nível 2
	elif nivel == 3:
		chance_drop = 0.45 # 45% de chance de dropar algo no nível 3 (Dificuldade máxima pede mais ajuda!)

	# Sorteia se vai dropar alguma coisa (Número aleatório entre 0.0 e 1.0)
	if randf() <= chance_drop:
		# Se passou no teste do drop, joga outra moeda para decidir QUAL item cai (50% / 50%)
		var item_escolhido = item_vida if randf() <= 0.5 else item_tiro
		
		# Instancia o item fisicamente no cenário
		var drop = item_escolhido.instantiate()
		
		# Define a posição de nascimento do item EXATAMENTE onde o professor morreu!
		drop.global_position = global_position
		
		# Adiciona o item à cena principal para ele ficar estático no chão do mapa
		get_tree().current_scene.add_child(drop)

	queue_free()
