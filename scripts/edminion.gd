extends CharacterBody2D

const SPEED = 100.0 # O inimigo deve ser mais lento que o jogador
var jogador_alvo: Node2D = null
@warning_ignore("narrowing_conversion")
var vida_maxima : int = 3.0
var vida_atual : int = vida_maxima

# 🟢 REFERÊNCIA AO SPRITE: Busca o nó Sprite2D do edminion
# (Certifique-se de que o nome do nó na aba Scene é exatamente Sprite2D)
@onready var sprite = $Sprite2D

# Essa função será chamada pela fase principal quando o inimigo nascer[cite: 3]
func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if jogador_alvo:
		# Calcula a direção do inimigo apontando para o jogador[cite: 3]
		var direction = global_position.direction_to(jogador_alvo.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		# 🟢 CONTROLE DO OLHAR (ESPELHAMENTO):
		# Se a posição X do jogador for menor que a do edminion, o jogador está na esquerda
		if jogador_alvo.global_position.x < global_position.x:
			# Se o seu sprite original já estiver virado para a esquerda, mude para false
			sprite.flip_h = true 
		else:
			# Se o jogador estiver na direita, deixa o sprite na orientação normal
			sprite.flip_h = false
		
func receber_dano (quantidade: int):
	@warning_ignore("narrowing_conversion")
	vida_atual -= quantidade
	print("Vida restante edminion: ", vida_atual)
	if vida_atual <= 0:
			morrer()
			
func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if game_manager:
		game_manager.adicionar_score(1)
	queue_free()
