extends CharacterBody2D

const SPEED = 100.0 # O inimigo deve ser mais lento que o jogador
var jogador_alvo: Node2D = null
@warning_ignore("narrowing_conversion")
var vida_maxima : int = 3.0
var vida_atual : int = vida_maxima


# Essa função será chamada pela fase principal quando o inimigo nascer
func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if jogador_alvo:
		# Calcula a direção do inimigo apontando para o jogador
		var direction = global_position.direction_to(jogador_alvo.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
func receber_dano (quantidade: float):
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
	
	
	
	
