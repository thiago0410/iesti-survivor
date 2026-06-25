extends Area2D

var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("receber_dano"):
		body.receber_dano(2)
		queue_free()
