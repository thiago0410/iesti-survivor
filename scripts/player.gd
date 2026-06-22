extends CharacterBody2D

# Velocidade de movimento em pixels por segundo
const SPEED = 200.0
var cena_projectile = preload("res://scenes/projectile.tscn")

var cadencia_tiro_original: float = 0.3 # Guarde o tempo padrão do seu timer de tiro [cite: 6]
@onready var timer_tiro = $TimerTiro # Referência ao seu timer de disparo existente [cite: 6]
@onready var timer_boost_tiro = Timer.new() # Cria um timer de duração do efeito [cite: 6]

# --- VARIÁVEIS PARA OS SPRITES ---
# O @export faz com que essas variáveis apareçam no painel Inspetor do Godot
@export var sprite_frente: Texture2D   # Visão de frente (olhando para baixo)
@export var sprite_costas: Texture2D   # Visão de costas (olhando para cima)
@export var sprite_esquerda: Texture2D # Visão olhando para a esquerda
@export var sprite_direita: Texture2D  # Visão olhando para a direita

@onready var sprite_nodo = $Sprite2D


var vida_maxima : int = 5
var vida_atual : int = vida_maxima

# Coloque logo abaixo das suas variáveis lá no topo:
func _ready():
	# Configura o timer de duração do boost
	add_child(timer_boost_tiro)
	timer_boost_tiro.one_shot = true
	timer_boost_tiro.timeout.connect(_on_boost_tiro_timeout)
	
	# Salva a cadência original para podermos resetar depois
	if timer_tiro:
		cadencia_tiro_original = timer_tiro.wait_time

func coletar_power_up():
	pass

func curar_vida(quantidade: int):
	vida_atual += quantidade
	# Impede que a vida passe do máximo (5 / 5)
	vida_atual = clamp(vida_atual, 0, vida_maxima)
	print("Vida curada! Atual: ", vida_atual)
	
	# Avisa a UI para atualizar a barra verde
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_vida(vida_atual)

func ativar_boost_tiro(duracao: float, multiplicador: float):
	print("Ativando tiro rápido!")
	
	# Se o timer de tiro não existir, não faz nada [cite: 6]
	if !timer_tiro: return
	
	# Aplica o multiplicador (ex: de 0.3s vira 0.15s) [cite: 6]
	timer_tiro.wait_time = 0.08
	
	# Inicia/reinicia a contagem de duração do efeito [cite: 6]
	timer_boost_tiro.start(duracao)

func _on_boost_tiro_timeout():
	print("Fim do tiro rápido.")
	
	# Reseta o tempo de disparo ao original [cite: 6]
	if timer_tiro:
		timer_tiro.wait_time = cadencia_tiro_original
		
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_timer_powerup(0.0)

func _physics_process(_delta):
	# Captura as teclas WASD ou setas do teclado[cite: 2]
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") #[cite: 2]
	
	# Aplica a direção à velocidade[cite: 2]
	velocity = direction * SPEED #[cite: 2]
	
	# Função embutida do CharacterBody2D para aplicar o movimento[cite: 2]
	move_and_slide() #[cite: 2]
	
	# 🛑 TRAVA DO PERSONAGEM NA TELA:
	# Definimos uma margem de segurança (ex: 32 pixels) para o sprite não ficar metade para fora
	var margem = 32.0
	
	# Se o timer do bônus estiver rodando, manda o tempo restante para a tela
	if timer_boost_tiro and timer_boost_tiro.time_left > 0.0:
		var ui = get_tree().current_scene.get_node_or_null("UI")
		if ui:
			ui.atualizar_timer_powerup(timer_boost_tiro.time_left)
	
	# O clamp limita o valor da posição entre o mínimo (margem) e o máximo (tamanho da tela menos a margem)
	global_position.x = clamp(global_position.x, margem, 1280.0 - margem)
	global_position.y = clamp(global_position.y, margem, 720.0 - margem)
	
	atualizar_direcao_olhar() 

func atualizar_direcao_olhar():
	# Calcula o vetor que aponta do jogador até o mouse
	var direcao_mouse = global_position.direction_to(get_global_mouse_position())
	
	# Pega o ângulo em radianos desse vetor. 
	# O Godot trabalha com radianos, onde:
	# Direita = 0 | Baixo = PI/2 (1.57) | Esquerda = PI ou -PI | Cima = -PI/2 (-1.57)
	var angulo = direcao_mouse.angle()
	
	# Mapeia os quadrantes (45 graus para cada lado de cada eixo)
	# 1. Olhando para a DIREITA (Ângulo entre -45° e 45°)
	if angulo > -0.785 and angulo <= 0.785:
		if sprite_direita: sprite_nodo.texture = sprite_direita
		
	# 2. Olhando para BAIXO / FRENTE (Ângulo entre 45° e 135°)
	elif angulo > 0.785 and angulo <= 2.356:
		if sprite_frente: sprite_nodo.texture = sprite_frente
		
	# 3. Olhando para CIMA / COSTAS (Ângulo entre -135° e -45°)
	elif angulo > -2.356 and angulo <= -0.785:
		if sprite_costas: sprite_nodo.texture = sprite_costas
		
	# 4. Olhando para a ESQUERDA (Qualquer outro ângulo nas extremidades)
	else:
		if sprite_esquerda: sprite_nodo.texture = sprite_esquerda


func _on_timer_projectile_timeout():
	# 1. Instancia o projétil do café na memória
	var projectile = cena_projectile.instantiate()
	
	# 2. Define a posição de nascimento do tiro (no centro do jogador)
	projectile.global_position = global_position
	
	# 3. MÁGICA DO MOUSE: Descobre a direção do jogador até o ponteiro do mouse
	# global_position.direction_to() calcula o vetor unitário apontando para o alvo
	var direcao_mouse = global_position.direction_to(get_global_mouse_position())
	
	# 4. Passa a direção correta para o projétil
	projectile.direction = direcao_mouse
	
	# 5. Opcional: Faz o sprite do tiro "olhar" (rotacionar) para o mouse
	projectile.rotation = direcao_mouse.angle()
	
	# 6. Adiciona o tiro na fase principal
	get_tree().current_scene.add_child(projectile)
	
func receber_dano (quantidade : int):
	vida_atual -= quantidade
	print("Vida restante personagem: ", vida_atual)
	
	# Atualiza a barra de vida na tela
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_vida(vida_atual)
	
	if vida_atual <= 0:
		game_over()

func game_over():
	print("Game Over!")
	# Mostra a mensagem de derrota na tela
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.mostrar_fim_de_jogo("GAME OVER!\nVocê acumulou DP nesta fase.", Color.RED)
	get_tree().paused = true


func _on_zona_dano_body_entered(body: Node2D) -> void:
	if body.name.contains("Inimigo") or body.has_method("definir_alvo"):
		receber_dano(1)
		body.queue_free()
