extends Node2D

@onready var player = $player
@onready var edminion = $edminion

func _ready():
	# Informa ao inimigo quem ele deve perseguir assim que o jogo iniciar
	edminion.definir_alvo(player)
