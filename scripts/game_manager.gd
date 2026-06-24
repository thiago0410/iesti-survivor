extends Node

var score: int = 0
var nivel_atual: int = 1

# Definição de pontos necessários para passar de nível (Fase 1 -> 2 -> 3)
@export var PONTOS_PARA_NIVEL_2: int = 2
@export var PONTOS_PARA_NIVEL_3: int = 5
@export var PONTOS_PARA_VENCER_JOGO: int = 8

# Referência ao Spawner para mudar a dificuldade
@onready var spawner = $"../spawnerInimigos"

func adicionar_score(quantidade: int):
	score += quantidade
	print("Score atual: ", score) 
	
	# Atualiza o score na tela
	var ui = get_tree().current_scene.get_node_or_null("UI")
	
	if ui:
		ui.atualizar_score(score)
		
	checar_progresao_nivel() #

func checar_progresao_nivel():
	if score >= PONTOS_PARA_VENCER_JOGO:
		vencer_jogo()
	elif nivel_atual == 1 and score >= PONTOS_PARA_NIVEL_2:
		passar_de_nivel(2)
		if has_node("SomLevelUp"):
			$SomLevelUp.play()
	elif nivel_atual == 2 and score >= PONTOS_PARA_NIVEL_3:
		passar_de_nivel(3)
		if has_node("SomLevelUp"):
			$SomLevelUp.play()

func passar_de_nivel(novo_nivel: int):
	nivel_atual = novo_nivel
	print("Nivel atual", nivel_atual)
	
	# Atualiza o nível na tela
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.atualizar_nivel(nivel_atual)
	
	# Altera a dificuldade do Spawner baseado no nível
	if spawner:
		spawner.atualizar_dificuldade(nivel_atual)
	
func vencer_jogo():
	print("Game win")
	
	# Mostra a mensagem de sucesso na tela exigida no trabalho
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if ui:
		ui.mostrar_fim_de_jogo("PARABÉNS!\nVocê passou do primeiro semestre na UNIFEI!", Color.GREEN)
	get_tree().paused = true # Pausa o jogo (Requisito obrigatório de sucesso)
