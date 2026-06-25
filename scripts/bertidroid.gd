extends CharacterBody2D

const SPEED = 70.0
const DISTANCIA_PARADA = 300.0
var jogador_alvo: Node2D = null
var vida_maxima: int = 2
var vida_atual: int = vida_maxima
var cena_tiro = preload("res://scenes/tiro_inimigo.tscn")
var esta_mirando: bool = false
@onready var timer_ataque = $AtaqueTimer
@onready var rastro_mira = $RastroMira
@onready var sprite = $Sprite2D

func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if !jogador_alvo: return
	var distancia = global_position.distance_to(jogador_alvo.global_position)
	var direcao = global_position.direction_to(jogador_alvo.global_position)
	if !esta_mirando and distancia > DISTANCIA_PARADA:
		velocity = direcao * SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO 
	if jogador_alvo.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if esta_mirando and rastro_mira != null:
		rastro_mira.clear_points()
		rastro_mira.add_point(Vector2.ZERO)
		var vetor_para_jogador = to_local(jogador_alvo.global_position)
		var distancia_total = vetor_para_jogador.length()
		var raio_colisao_player = 23.0 
		var distancia_ajustada = max(0.0, distancia_total - raio_colisao_player)
		var ponto_final = vetor_para_jogador.normalized() * distancia_ajustada
		rastro_mira.add_point(ponto_final)

func _on_ataque_timer_timeout():
	if !jogador_alvo: return
	esta_mirando = true
	await get_tree().create_timer(1.0).timeout
	if rastro_mira != null:
		rastro_mira.clear_points()
	esta_mirando = false
	if jogador_alvo:
		var tiro = cena_tiro.instantiate()
		tiro.direction = global_position.direction_to(jogador_alvo.global_position)
		tiro.global_position = global_position
		get_tree().current_scene.add_child(tiro)
		$SomTiro.play()

func receber_dano(quantidade: int):
	vida_atual -= quantidade
	if vida_atual <= 0:
		morrer()

func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if not game_manager:
		game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if game_manager:
		game_manager.adicionar_score(2)
	queue_free()
