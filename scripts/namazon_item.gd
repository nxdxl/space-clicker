extends Control

signal item_purchased

@onready var item_image = $%ItemImage
@onready var gold_coin_animation = $%GoldCoinAnimation
@onready var purchase_button = $%PurchaseButton
@onready var item_name_label = $%ItemName

var item: ItemData


func _ready() -> void:
	if not item:
		return
	item_name_label.text = item.item_name
	item_image.texture = item.texture
	gold_coin_animation.play("main_animation")
	purchase_button.text = str(item.price)
	purchase_button.disabled = !Item.is_purchaseable(item)
	if item.purchased:
		purchase_button.disabled = true
		purchase_button.text = "   PURCHASED" # i know, this is cheating :skull:


func _on_purchase_button_pressed() -> void:
	
	# -------------------------- #
	#        ACHIEVEMENTS        #
	# -------------------------- #
	
	if item.item_type == Item.ItemName.MAGMA_SPOON:
		Player.achieve(Achievements.Achievement.HERE_COMES_THE_AIRPLANE)
	
	item.purchased = true
	item.level = 1
	match item.item_type:
		Item.ItemName.PICKAXE:
			_handle_pickaxe_purchase()
		Item.ItemName.BUCKET:
			_handle_bucket_purchase()
		Item.ItemName.METEORITE_SHIELD:
			_handle_shield_purchase()
		Item.ItemName.MAGMA_SPOON:
			_handle_spoon_purchase()
	Player.space_dollars -= item.price
	var nr_purchased_items: Array[bool]
	for itm in Player.item_list:
		if itm.purchased:
			nr_purchased_items.append(itm.purchased)
		if itm.item_name == item.item_name:
			itm = item
	if nr_purchased_items.size() == Player.item_list.size() - 1:
		Player.achieve(Achievements.Achievement.COLLECTOR)
	emit_signal("item_purchased")
	UI.refresh_side_bar()


func _handle_shield_purchase():
	Player.health += 100


func _handle_pickaxe_purchase():
	Player.damage += 100


func _handle_bucket_purchase():
	Player.health += 50


func _handle_spoon_purchase():
	Player.health = (Player.health + 100) * 2
