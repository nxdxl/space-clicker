extends Resource
class_name SaveData

@export var player_name: String
@export var max_health: int
@export var health: int
@export var damage: int
@export var ore_dictionary: Dictionary
@export var item_list: Array[ItemData]
@export var shop_items: Array[ItemData]
@export var total_clicks: int
@export var total_time_spent: float
@export var space_dollars: int
@export var checkpoints: Dictionary[String, bool]
@export var defeated_ruru: bool
@export var achievements: Array[Achievements.Achievement]
@export var total_space_dollars: int
@export var hidden_achievements: Array[Achievements.HiddenAchievement]
@export var rank: Ranks.Rank
