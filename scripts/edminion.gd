extends CharacterBody2D

const SPEED = 100.0
var jogador_alvo: Node2D = null
var vida_maxima : int = 3.0
var vida_atual : int = vida_maxima
var item_vida = preload("res://scenes/power_ups/power_up_vida.tscn")
var item_tiro = preload("res://scenes/power_ups/power_up_tiro_rapido.tscn")
@onready var sprite = $Sprite2D
@warning_ignore("narrowing_conversion")

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

func receber_dano(quantidade: int):
	vida_atual -= quantidade
	print("Vida restante edminion: ", vida_atual)
	if vida_atual <= 0:
		morrer()

func morrer():
	var game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	if not game_manager:
		game_manager = get_tree().current_scene.get_node_or_null("gameManager")
	var nivel = 1
	var chance_drop = 0.15 
	if game_manager:
		game_manager.adicionar_score(1)
		nivel = game_manager.nivel_atual
	if nivel == 1:
		chance_drop = 0.15
	elif nivel == 2:
		chance_drop = 0.30 
	elif nivel == 3:
		chance_drop = 0.45

	if randf() <= chance_drop:
		var item_escolhido = item_vida if randf() <= 0.5 else item_tiro
		var drop = item_escolhido.instantiate()
		drop.global_position = global_position
		get_tree().current_scene.add_child(drop)
	queue_free()
