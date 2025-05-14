extends Control

signal item_purchased
signal refresh_namazon

@onready var item_image = $%ItemImage
@onready var gold_coin_animation = $%GoldCoinAnimation
@onready var purchase_button = $%PurchaseButton
@onready var item_name_label = $%ItemName

var item: ItemData


func _ready() -> void:
	item_name_label.text = item.item_name
	item_image.texture = item.texture
	gold_coin_animation.play("main_animation")
	purchase_button.disabled = !Item.is_purchaseable(item)
	if item.purchased:
		purchase_button.disabled = true
		purchase_button.text = "   PURCHASED" # i know, this is cheating :skull:


func _on_purchase_button_pressed() -> void:
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
	for itm in Player.item_list:
		if itm.item_name == item.item_name:
			itm = item
	emit_signal("item_purchased")
	emit_signal("refresh_namazon")


func _handle_shield_purchase():
	Player.health += 100


func _handle_pickaxe_purchase():
	Player.damage += 100


func _handle_bucket_purchase():
	Player.health += 50


func _handle_spoon_purchase():
	Player.health = (Player.health + 100) * 2
