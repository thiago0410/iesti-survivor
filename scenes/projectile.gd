extends Area2D

var speed = 400.0
var direction = Vector2.RIGHT
var dano: float = 1.0

func _process(delta):
	# Se você rotacionou o tiro no player, Vector2.RIGHT.rotated(rotation) 
	# fará ele andar exatamente para "frente" de onde ele está olhando!
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(body):
	if body.has_method("receber_dano"):
		body.receber_dano(dano)
		queue_free()
