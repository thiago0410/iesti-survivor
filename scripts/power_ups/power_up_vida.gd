extends PowerUpBase # 🟢 Estende da base, não do Area2D!

# QUANTIDADE_VIDA: Quanta vida ele cura
@export var quantidade_cura: int = 1

# 🟢 SUBSTITUIÇÃO: Reescrevemos a função abstrata da base
func aplicar_efeito(player):
	print("Coletou Vida!")
	
	# Chama a função de curar que devemos criar no player.gd
	if player.has_method("curar_vida"):
		player.curar_vida(quantidade_cura)
