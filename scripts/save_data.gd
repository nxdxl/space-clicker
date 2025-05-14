extends Resource
class_name SaveData

@export var max_health: int = 10
@export var health: int = 10
@export var damage: int = 1
@export var ore_dictionary: Dictionary
@export var item_list: Array[ItemData]
@export var shop_items: Array[ItemData]
@export var total_clicks: int = 0
@export var total_time_spent: float = 0
@export var space_dollars: int = 0
@export var checkpoints: Dictionary[String, bool]
@export var defeated_ruru: bool = false
