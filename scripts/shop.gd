extends Control

var stones = 0
var spd = 0
var hp = 0
var cost = 0

func _ready():
	get_tree().get_root().get_node("pub").load_game()
	#print(get_tree().get_nodes_in_group("player")[0])
	self.stones = get_tree().get_nodes_in_group("player")[0].stones
	self.rect_global_position = -get_viewport_rect().size/4
	$VBoxContainer/Label.text = "STORE " + str(stones) + "G"
	update()

func update():
	$VBoxContainer/GridContainer/speedNumLabel.text = "+|"+str(spd)+"|"
	$VBoxContainer/GridContainer/hpNumLabel.text = "+|"+str(hp)+"|"
	$VBoxContainer/doneButton.text = "BUY "+str(cost)+"G"

func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		get_parent().in_shop = false
		self.queue_free()

func _on_plusSpd_pressed():
	if cost+10<=stones:
		spd += 1
		cost += 10
		update()

func _on_minusSpd_pressed():
	if spd > 0:
		spd -= 1
		cost -= 10
		
		update()
		
func _on_minusHp_pressed():
	if hp > 0:
		hp -= 1
		cost -= 10
		update()
		
func _on_plusHp_pressed():
	if cost+10<=stones:
		hp += 1
		cost += 10
		update()


func _on_doneButton_pressed():
	if cost <= stones:
		get_tree().get_nodes_in_group("player")[0].stones -= cost
		get_tree().get_nodes_in_group("player")[0].SPEED += spd * 10
		get_tree().get_nodes_in_group("player")[0].max_hp += hp * 5
		get_tree().get_root().get_node("pub").save()
		get_parent().in_shop = false
		self.queue_free()
