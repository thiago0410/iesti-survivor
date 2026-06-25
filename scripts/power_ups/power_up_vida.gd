extends PowerUpBase

@export var quantidade_cura: int = 1

# aplica o efeito de cura
func aplicar_efeito(player):
	print("Coletou Vida!")
	if player.has_method("curar_vida"):
		player.curar_vida(quantidade_cura)
