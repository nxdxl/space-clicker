extends Node

enum Rank {
	LEAF,
	TWIG,
	SILVER,
	GOLD,
	DIAMOND,
	PLATINUM,
}


var rank_reqs: Dictionary[Rank, Array] = {
	# all achievement reqs are incremental, so i don't need to check prior ones
	Rank.LEAF: [Achievements.Achievement.MEET_FURO],
	Rank.TWIG: [Achievements.Achievement.USELESS_UPGRADE, Achievements.Achievement.NEWCOMER, Achievements.Achievement.CLICKING_IS_FUN],
	Rank.SILVER: [Achievements.Achievement.RICH_KID, Achievements.Achievement.HERE_COMES_THE_AIRPLANE],
	Rank.GOLD: [Achievements.Achievement.THE_BEST_ENGINE, Achievements.Achievement.COLLECTOR],
	Rank.DIAMOND: [Achievements.Achievement.WEALTHY, Achievements.Achievement.ON_FIRE, Achievements.Achievement.KNOWN],
	Rank.PLATINUM: [Achievements.Achievement.MY_FINGER_IS_TIRED, Achievements.Achievement.HOW],
}

var rank_images: Dictionary[Rank, Texture2D] = {
	Rank.LEAF: preload("res://img/ranks/leaf.png"),
	Rank.TWIG: preload("res://img/ranks/twig.png"),
	Rank.SILVER: preload("res://img/ranks/silver.png"),
	Rank.GOLD: preload("res://img/ranks/gold.png"),
	Rank.DIAMOND: preload("res://img/ranks/diamond.png"),
	Rank.PLATINUM: preload("res://img/ranks/platinum.png"),
}


func check_rank_reqs(rank: Rank) -> bool:
	# very fancy -- basically checking if list1 is a subset of list2
	return rank_reqs[rank].all(func(x): return x in Player.achievements)
