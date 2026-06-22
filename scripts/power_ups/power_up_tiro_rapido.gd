extends PowerUpBase # 🟢 Estende da base

# Configurações do efeito temporário
@export var duracao_efeito: float = 6.0 # 6 segundos de tiro rápido
@export var multiplicador_cadencia: float = 0.5 # Corta o tempo de espera pela metade (0.5x)

func aplicar_efeito(player):
	print("Coletou Tiro Rápido!")
	
	# Chama a função de boost que devemos criar no player.gd
	if player.has_method("ativar_boost_tiro"):
		player.ativar_boost_tiro(duracao_efeito, 0.0)
