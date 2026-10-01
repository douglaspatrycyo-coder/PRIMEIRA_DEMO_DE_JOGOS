extends Node2D


var tabuleiro = ["", "", "", "", "", "", "", "", ""]
var vez_do_jogador = true  
var jogo_acabou = false
var vitorias_jeffim = 0
var vitorias_capeta = 0
var empates = 0

@onready var label_placar = get_node("UI/placar")
@onready var label_status = get_node("UI/Label")

func _ready():
	for i in range(1,10):
		var botao = get_node("tabuleiro/casa" + str(i))
		botao.pressed.connect(func(): jogar(i-1, botao))
	get_node("UI/BotãoReiniciar").pressed.connect(reiniciar)
	atualiza_placar()
	
func jogar(posicao: int, botao: Button):
	if jogo_acabou or tabuleiro[posicao] != "":
		return

	if vez_do_jogador:
		tabuleiro[posicao] = "X"
		botao.text = "X"
	else:
		tabuleiro[posicao] = "O"
		botao.text = "O"

	var resultado = checar_vitoria()
	if resultado == "X":
		vitorias_jeffim += 1
		jogo_acabou = true
		label_status.text = "Jeffim venceu...infelizmente"
	elif resultado == "O":
		vitorias_capeta += 1
		jogo_acabou = true
		label_status.text = "O Capeta comeu a alma do Jeffim..."
	elif resultado == "empate":
		empates +=1
		jogo_acabou = true
		label_status.text = "Decidiram no par ou ímpar"
	else:
		vez_do_jogador = not vez_do_jogador
		if vez_do_jogador:
			label_status.text = "Vez de Jeffim"
		else:
			label_status.text = "Vez do Capeta"
	
	atualiza_placar()
	
func checar_vitoria() -> String:
	var combinacoes = [
		[0,1,2], [3,4,5], [6,7,8],  # linhas
		[0,3,6], [1,4,7], [2,5,8],  # colunas
		[0,4,8], [2,4,6]            # diagonais
	]

	for c in combinacoes:
		var a = tabuleiro[c[0]]
		var b = tabuleiro[c[1]]
		var d = tabuleiro[c[2]]
		if a != "" and a == b and b == d:
			return a  # retorna "X" ou "O", quem venceu

	if not tabuleiro.has(""):
		return "empate"  # todas as casas preenchidas, ninguém venceu

	return ""  # jogo continua
	
func reiniciar():
	tabuleiro = ["", "", "", "", "", "", "", "", ""]
	vez_do_jogador = true 
	jogo_acabou = false	
	label_status.text = "Vez de Jeffim"
	
	for i in range(1,10):
		var botao = get_node("tabuleiro/casa" + str(i))
		botao.text = ""

func atualiza_placar():
	label_placar.text = "Jeffim: %d  Capeta: %d  Empates: %d" %[vitorias_jeffim,vitorias_capeta,empates]
	
	
