extends Node2D

var cards = [
	{"command": 'git add .', "arg_number": 0},
	{"command": 'git checkout', "arg_number": 1},
	{"command": 'touch "file$RANDOM"', "arg_number": 0},
	{"command": 'git commit --allow-empty -m "$RANDOM"', "arg_number": 0},
	{"command": 'git checkout -b "$RANDOM"', "arg_number": 0},
	{"command": 'git merge', "arg_number": 1},
	{"command": 'git symbolic-ref HEAD', "arg_number": 1},
	{"command": 'git update-ref -d', "arg_number": 1},
	{"command": 'git reflog expire --expire=now --all; git prune', "arg_number": 0},
	{"command": 'git rebase', "arg_number": 1}
]

func _ready():
	
	var path = game.tmp_prefix_inside+"/repos/sandbox/"
	helpers.careful_delete(path)
	
	game.global_shell.run("mkdir " + path)
	game.global_shell.cd(path)
	game.global_shell.run("git init")
	game.global_shell.run("git symbolic-ref HEAD refs/heads/main")
	game.global_shell.run("git commit --allow-empty -m 'Initial commit'")
	
	$Repository.path = path

	$Terminal.repository = $Repository
	
	redraw_all_cards()

func _update_repo():
	$Repository.update_everything()
	
func draw_rand_card():
	var new_card = preload("res://card.tscn").instance()
	var card = cards[randi() % cards.size()]
	new_card.command = card.command
	new_card.arg_number = card.arg_number
	new_card.position = Vector2(rand_range(200, get_viewport().size.x - 200), get_viewport().size.y*3/4 + rand_range(-200,200))
	add_child(new_card)
	
func redraw_all_cards():
	for card in get_tree().get_nodes_in_group("cards"):
		card.queue_free()
	for i in range(10):
		draw_rand_card()
	
