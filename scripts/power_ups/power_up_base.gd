extends Area2D
class_name PowerUpBase

var tempo_decorrido: float = 0.0
var amplitude_flutuacao: float = 5.0 
var velocidade_flutuacao: float = 4.0 
@onready var sprite = $Sprite2D
@onready var som_coleta = $SomColeta

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	tempo_decorrido += delta
	sprite.position.y = sin(tempo_decorrido * velocidade_flutuacao) * amplitude_flutuacao

func _on_body_entered(body):
	if body.has_method("coletar_power_up"):
		if som_coleta and som_coleta.stream:
			som_coleta.play()
		aplicar_efeito(body)
		sprite.visible = false
		monitoring = false
		if som_coleta and som_coleta.stream and som_coleta.playing:
			await som_coleta.finished
		queue_free()

func aplicar_efeito(_player):
	pass
