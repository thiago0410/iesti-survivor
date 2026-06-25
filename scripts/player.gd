extends CharacterBody2D

const SPEED = 200.0
var cena_projectile = preload("res://scenes/projectile.tscn")
var vida_maxima : int = 5
var vida_atual : int = vida_maxima
var cadencia_tiro_original: float = 0.3
@onready var timer_tiro = $TextoTimerTiro 
@onready var timer_boost_tiro = Timer.new() 
@export var sprite_frente: Texture2D  
@export var sprite_costas: Texture2D   
@export var sprite_esquerda: Texture2D 
@export var sprite_direita: Texture2D  
@onready var sprite_nodo = $Sprite2D

func _ready():
	add_child(timer_boost_tiro)
	timer_boost_tiro.one_shot = true
	timer_boost_tiro.timeout.connect(_on_boost_tiro_timeout)
	if timer_tiro:
		cadencia_tiro_original = timer_tiro.wait_time

func coletar_power_up():
	pass

# adiciona vida ao personagem
func curar_vida(quantidade: int):
	vida_atual += quantidade
	vida_atual = clamp(vida_atual, 0, vida_maxima)
	print("Vida curada! Atual: ", vida_atual)
	
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_vida(vida_atual)

# ativa power up de tiro rapido
func ativar_boost_tiro(duracao: float, multiplicador: float):
	print("Ativando tiro rápido!")
	if !timer_tiro: return
	timer_tiro.wait_time = 0.08 # diminui o tempo de espera do disparo
	timer_boost_tiro.start(duracao)

# retorna a cadencia de tiro normal quando o power up acaba
func _on_boost_tiro_timeout():
	print("Fim do tiro rápido.")
	if timer_tiro:
		timer_tiro.wait_time = cadencia_tiro_original
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_timer_powerup(0.0)

# movimentacao do personagem
func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") #[cite: 2]
	velocity = direction * SPEED #[cite: 2]
	move_and_slide() 
	var margem = 32.0
	if timer_boost_tiro and timer_boost_tiro.time_left > 0.0:
		var ui = get_tree().current_scene.get_node_or_null("UI")
		if ui:
			ui.atualizar_timer_powerup(timer_boost_tiro.time_left)
	global_position.x = clamp(global_position.x, margem, 1280.0 - margem)
	global_position.y = clamp(global_position.y, margem, 720.0 - margem)
	atualizar_direcao_olhar() 

# calcula o angulo entre o personagem e o mouse
# e troca o sprite de acordo com o angulo
func atualizar_direcao_olhar():
	var direcao_mouse = global_position.direction_to(get_global_mouse_position())
	var angulo = direcao_mouse.angle()
	if angulo > -0.785 and angulo <= 0.785:
		if sprite_direita: sprite_nodo.texture = sprite_direita
	elif angulo > 0.785 and angulo <= 2.356:
		if sprite_frente: sprite_nodo.texture = sprite_frente
	elif angulo > -2.356 and angulo <= -0.785:
		if sprite_costas: sprite_nodo.texture = sprite_costas
	else:
		if sprite_esquerda: sprite_nodo.texture = sprite_esquerda

# atira o projetil do personagem
func _on_timer_projectile_timeout():
	var projectile = cena_projectile.instantiate()
	projectile.global_position = global_position
	var direcao_mouse = global_position.direction_to(get_global_mouse_position())
	projectile.direction = direcao_mouse
	projectile.rotation = direcao_mouse.angle()
	get_tree().current_scene.add_child(projectile)
	if has_node("SomTiro"):
		$SomTiro.play()

# diminui a vida do personagem conforme recebe dano
func receber_dano (quantidade : int):
	vida_atual -= quantidade
	print("Vida restante personagem: ", vida_atual)
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_vida(vida_atual)
	if vida_atual <= 0:
		game_over()

# avisa a UI que o personagem morreu
func game_over():
	print("Game Over!")
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.mostrar_fim_de_jogo("GAME OVER!\nVocê acumulou DP nesta fase.", Color.RED)
	get_tree().paused = true

# area de colisao que recebe o dano (contato ou projetil)
func _on_zona_dano_body_entered(body: Node2D) -> void:
	if body.name.contains("Inimigo") or body.has_method("definir_alvo"):
		receber_dano(1)
		body.queue_free()
