extends CharacterBody2D

const SPEED = 50.0
var jogador_alvo: Node2D = null
var vida_maxima: int = 1
var vida_atual: int = vida_maxima
var cena_magia = preload("res://scenes/magia_area.tscn")
@onready var sprite = $Sprite2D

func definir_alvo(alvo):
	jogador_alvo = alvo

func _physics_process(_delta):
	if !jogador_alvo: return
	var direcao = global_position.direction_to(jogador_alvo.global_position)
	velocity = direcao * SPEED
	move_and_slide()
	if jogador_alvo.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _on_mago_timer_timeout():
	if !jogador_alvo: return
	var magia = cena_magia.instantiate()
	magia.global_position = jogador_alvo.global_position
	get_tree().current_scene.add_child(magia)

func receber_dano(quantidade: int):
	vida_atual -= quantidade
	if vida_atual <= 0:
		morrer()

func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if not game_manager:
		game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if game_manager:
		game_manager.adicionar_score(3)  
	queue_free()
