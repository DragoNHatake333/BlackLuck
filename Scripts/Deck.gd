extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.5
const cards_that_shoud_be_in_center = 3
var cards_to_deal = 0
var drawing_cards = false

func _on_game_manager_call_deck() -> void:
	print("Deck: Deck called!")
	Globals.centerDeck.shuffle()
	
	if Globals.cards_in_center_hand < cards_that_shoud_be_in_center:
		cards_to_deal = cards_that_shoud_be_in_center - Globals.cards_in_center_hand
		drawing_cards = true
		draw_card(cards_to_deal)
		while drawing_cards == true:
			await get_tree().process_frame
	else:
		print("Deck: Center hand already has enough cards, no more dealt.")
	Globals.deckTurn = false

func _ready() -> void:
	$RichTextLabel.text = str(Globals.centerDeck.size())

func draw_card(reps):
	print(Globals.centerDeck.size(), " AAAAAAAAAAAAAAAAAAAA")
	var drawn = 0

	while drawn < reps:
		if Globals.centerDeck.size() <= 3:
			Globals.centerDeck = Globals.fullCenterDeck.duplicate()
		
		var card_drawn_name = Globals.centerDeck[0]

		# If a card with the same name exists, skip this draw
		if $"../CardManager".has_node(card_drawn_name):
			print("Duplicate card '%s' found, trying next draw..." % card_drawn_name)
			# Still erase the card so we don't try it again this session
			Globals.centerDeck.erase(card_drawn_name)
			continue

		Globals.centerDeck.erase(card_drawn_name)
		Globals.cards_in_center_hand += 1
		$RichTextLabel.text = str(Globals.centerDeck.size())

		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		var card_image_path = "res://Cards/" + card_drawn_name + ".png"
		new_card.get_node("CardImage").texture = load(card_image_path)
		new_card.name = card_drawn_name
		$"../CardManager".add_child(new_card)

		$"../CenterHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)

		drawn += 1  # Only increment if a unique card was drawn

	drawing_cards = false
