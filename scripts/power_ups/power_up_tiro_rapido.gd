extends PowerUpBase

@export var duracao_efeito: float = 5.0
@export var multiplicador_cadencia: float = 0.5

func aplicar_efeito(player):
	print("Coletou Tiro Rápido!")
	if player.has_method("ativar_boost_tiro"):
		player.ativar_boost_tiro(duracao_efeito, 0.0)
