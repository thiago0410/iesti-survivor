extends Area2D
class_name PowerUpBase # Define um nome de classe para facilitar a identificação

# Variáveis para animação de flutuar (Capricho Estético)
var tempo_decorrido: float = 0.0
var amplitude_flutuacao: float = 5.0 # Quantos pixels ele sobe e desce
var velocidade_flutuacao: float = 4.0 # Quão rápido ele oscila
@onready var sprite = $Sprite2D
@onready var som_coleta = $SomColeta

func _ready():
	# Conecta o sinal nativo de colisão ao script
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Animação simples de flutuar usando Seno
	tempo_decorrido += delta
	sprite.position.y = sin(tempo_decorrido * velocidade_flutuacao) * amplitude_flutuacao

func _on_body_entered(body):
	# Se quem entrou na área tem o método 'coletar_power_up'
	if body.has_method("coletar_power_up"):
		# Toca o som (se houver) e aplica o efeito específico (definido na filha)
		if som_coleta and som_coleta.stream:
			som_coleta.play()
		
		# Chama a função abstrata que as cenas filhas VÃO substituir
		aplicar_efeito(body)
		
		# Oculta o visual imediatamente para parecer que sumiu,
		# mas espera o som acabar (se houver) para dar queue_free()
		sprite.visible = false
		monitoring = false # Desliga colisão para não pegar duas vezes
		
		if som_coleta and som_coleta.stream and som_coleta.playing:
			await som_coleta.finished
		
		queue_free()

# ⚠️ FUNÇÃO ABSTRATA: Não escreva nada aqui. 
# As cenas filhas vão reescrever essa função com o efeito real.
func aplicar_efeito(_player):
	pass
