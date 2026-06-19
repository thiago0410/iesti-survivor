extends Area2D

var tempo_aviso: float = 1.2
var tempo_decorrido: float = 0.0
var esta_explodindo: bool = false
var raio_ataque: float = 45.0

@onready var colisao = $CollisionShape2D
@onready var visual_explosao = $VisualExplosao
@onready var parede_inimigos_colisao = $ParedeInimigos/CollisionShape2D

func _ready():
	# Começa com a colisão de dano desligada
	colisao.disabled = true
	if visual_explosao:
		visual_explosao.visible = false
	
	if colisao and colisao.shape is CircleShape2D:
		raio_ataque = colisao.shape.radius
		
	# Conecta o sinal de entrada de corpos ao próprio script para garantir o dano
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(tempo_aviso).timeout.connect(realizar_ataque)

func _process(delta):
	if esta_explodindo: return
	tempo_decorrido += delta
	queue_redraw()

func _draw():
	if esta_explodindo: return
	var progresso = clamp(tempo_decorrido / tempo_aviso, 0.0, 1.0)
	var alfa_preenchimento = lerp(0.15, 0.65, progresso)
	var cor_preenchimento = Color(1.0, 0.0, 0.0, alfa_preenchimento)
	var cor_borda = Color(1.0, 0.0, 0.0, 0.9)
	
	draw_circle(Vector2.ZERO, raio_ataque, cor_preenchimento)
	draw_arc(Vector2.ZERO, raio_ataque, 0, PI * 2, 32, cor_borda, 2.0, true)

func realizar_ataque():
	esta_explodindo = true
	queue_redraw()
	
	# Desliga a parede invisível para que os inimigos possam voltar a andar por ali após a explosão
	if parede_inimigos_colisao:
		parede_inimigos_colisao.disabled = true
	
	if has_node("EfeitoExplosao"):
		$EfeitoExplosao.emitting = true
	
	if visual_explosao:
		visual_explosao.visible = true
		
	# Ativa a colisão de dano. Qualquer corpo dentro da área disparará o sinal instantaneamente!
	colisao.disabled = false
	
	await get_tree().create_timer(0.5).timeout
	queue_free()

# 🟢 NOVA FUNÇÃO DE DANO GERAL: Acionada via Sinal nativo
func _on_body_entered(body):
	# Se o jogo estiver na fase de explosão e o corpo for o jogador, aplica o dano
	if esta_explodindo and body.has_method("receber_dano"): 
		body.receber_dano(3)
