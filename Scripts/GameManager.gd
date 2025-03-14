extends Node
#Health
var healthP1 = 0
var healthP2 = 3
#Who owns the turn
var ownsTurn = false
#Amount of cards on players hand
var cardAmountP1 = 0
var cardAmountP2 = 0
#Which cards are in players hand
var cardHandP1 = {}
var cardHandP2 = {}
#Are we in the state of a saveround? (The one who started has 5 cards)
var saveRound = false
#Has someone won?
var endgame = false
#Who owned the first round
var firstRound = 0
#Total sum of cards in hand
var cardSumP1 = 0
var cardSumP2 = 0
# Who wins
var winP1 = false
var winP2 = false
#Turn number
var turnNumber = 0
var roundNumber = 0
var saveRoundHappened = false

#Signals
signal callCroupier
var Croupier = "/root/Main/Croupier"
signal callPlayer
var Player = "/root/Main/Player"
signal callAI
var AI = "/root/Main/AI"

func callingCroupier():
	callCroupier.emit()
	while Globals.croupierFinished == false:
		await get_tree().create_timer(4.0).timeout
		print("Waiting 4 second...")
	print("GameManager: Croupier is done!")
	Globals.croupierFinished = false
func callingPlayer():
	callPlayer.emit()
	while Globals.playerFinished == false:
		await get_tree().create_timer(4.0).timeout
		print("Waiting 4 second...")
	print("GameManager: Player is done!")
	Globals.playerFinished = false
func callingAI():
	callAI.emit()
	while Globals.aiFinished == false:
		await get_tree().create_timer(4.0).timeout
		print("Waiting 4 second...")
	print("GameManager: AI is done!")
	Globals.aiFinished = false
func playing():
	callingCroupier()
	if ownsTurn == false:
		callingPlayer()
	elif ownsTurn == true:
		callingAI()
	turnNumber += 1
	ownsTurn = !ownsTurn
	_ready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.set_max_fps(240)
	
	print("GameManager: GameManager is on.")
	if healthP1 == 0:
		print("Player 1 dies...")
		endgame = true
	elif healthP2 == 0:
		print("Player 2 dies...")
		endgame = true
	else:
		if cardAmountP2 or cardAmountP1 == 5:
			if saveRound == true:
				if cardSumP1 > cardSumP2:
					healthP2 -= 1
				elif cardSumP2 > cardSumP1:
					healthP1 -= 1
				saveRound = false
				playing()
			elif firstRound == true and cardAmountP2 == 5 or cardAmountP1 == 5 and firstRound == false:
				saveRound = true
				playing()
			else:
				playing()
		else:
			playing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
