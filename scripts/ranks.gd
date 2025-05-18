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
	Rank.LEAF: [Achievements.Achievement.MEET_FURO],
	Rank.TWIG: [Achievements.Achievement.USELESS_UPGRADE, Achievements.Achievement.NEWCOMER, Achievements.Achievement.CLICKING_IS_FUN],
	Rank.SILVER: [Achievements.Achievement.RICH_KID, Achievements.Achievement.HERE_COMES_THE_AIRPLANE],
	Rank.GOLD: [Achievements.Achievement.THE_BEST_ENGINE, Achievements.Achievement.COLLECTOR],
	Rank.DIAMOND: [Achievements.Achievement.WEALTHY, Achievements.Achievement.ON_FIRE, Achievements.Achievement.KNOWN],
	Rank.PLATINUM: [Achievements.Achievement.MY_FINGER_IS_TIRED, Achievements.Achievement.HOW, Achievements.Achievement.THE_FALLEN_ANGEL],
}

var rank_images: Dictionary[Rank, Texture2D] = {
	Rank.LEAF: preload("res://img/ranks/leaf.png"),
	Rank.TWIG: preload("res://img/ranks/twig.png"),
	Rank.SILVER: preload("res://img/ranks/silver.png"),
	Rank.GOLD: preload("res://img/ranks/gold.png"),
	Rank.DIAMOND: preload("res://img/ranks/diamond.png"),
	Rank.PLATINUM: preload("res://img/ranks/platinum.png"),
}

var rank_names: Dictionary[Rank, String] = {
	Rank.LEAF: "Leaf",
	Rank.TWIG: "Twig",
	Rank.SILVER: "Silver",
	Rank.GOLD: "Gold",
	Rank.DIAMOND: "Diamond",
	Rank.PLATINUM: "Platinum",
}


func check_rank_reqs(rank: Rank) -> bool:
	# lazy way of checking if the player is at max rank
	if rank >= rank_reqs.size():
		return false
	for chvmnt in rank_reqs[rank]:
		if chvmnt not in Player.achievements:
			return false
	return true
