extends Node

var achievement_image: Texture2D = preload("res://img/ranks/achievement.png")


enum Achievement {
	MEET_FURO, # meet furo for the first time
	USELESS_UPGRADE, # get a better engine
	AN_EVEN_BETTER_ENGINE, # get an exotic engine
	THE_BEST_ENGINE, # get a stardust engine
	THE_FALLEN_ANGEL, # defeat ruru
	RICH_KID, # earn X amount of money in total
	THE_RICHEST_KID, # earn even more than X amount of money
	WEALTHY, # earn EVEN MORE X amount of money
	HERE_COMES_THE_AIRPLANE, # get a magma spoon
	ALL_GOOD_THINGS_COME_IN_THREES, # die three times / yes, this saying actually exists in english haha
	COLLECTOR, # buy all items from the shop
	CLICKING_IS_FUN, # click a total of 100 times
	ON_FIRE, # click a total of 1000 times
	MY_FINGER_IS_TIRED, # click a total of 10000 times.
	NEWCOMER, # spent 10 minutes in total in game
	KNOWN, # spent 1 hour in total in game
	HOW, # spent 10 hours in total in game
	GODMODE, # activate god mode for the first time
	DUMMY,
}


# hidden achievements aren't yet available in the game.
# sorry if you tried to get them hahaha
enum HiddenAchievement {
	ALL_BEGINNINGS_ARE_HARD, # die in your first battle
	HOLY_ICE_CREAM, # get a holy ice cream
	VERY_EXOTIC, # mine an exotic matter ore
	DUMMY,
}


var achievement_names: Dictionary[Achievement, String] = {
	Achievement.MEET_FURO: "Furo",
	Achievement.USELESS_UPGRADE: "Useless??",
	Achievement.AN_EVEN_BETTER_ENGINE: "To Go Beyond",
	Achievement.THE_BEST_ENGINE: "To Go Even Further",
	Achievement.THE_FALLEN_ANGEL: "The Fallen Angel",
	Achievement.RICH_KID: "Rich Kid",
	Achievement.THE_RICHEST_KID: "Richest Kid On The Block",
	Achievement.WEALTHY: "Wealthy",
	Achievement.HERE_COMES_THE_AIRPLANE: "Here Comes The Airplane~",
	Achievement.ALL_GOOD_THINGS_COME_IN_THREES: "All Good Things Come In Threes",
	Achievement.COLLECTOR: "Collector",
	Achievement.CLICKING_IS_FUN: "Clicking Is Fun",
	Achievement.ON_FIRE: "ON FIRE",
	Achievement.MY_FINGER_IS_TIRED: "Finger Dead",
	Achievement.NEWCOMER: "Newcomer",
	Achievement.KNOWN: "Well Known",
	Achievement.HOW: "How.",
	Achievement.GODMODE: "God Mode.",
	Achievement.DUMMY: "Dummy Achievement",
}

var req_space_dollars: Dictionary[Achievement, int] = {
	Achievement.RICH_KID: 1000,
	Achievement.THE_RICHEST_KID: 10000,
	Achievement.WEALTHY: 100000,
}

var req_clicks: Dictionary[Achievement, int] = {
	Achievement.CLICKING_IS_FUN: 100,
	Achievement.ON_FIRE: 1000,
	Achievement.MY_FINGER_IS_TIRED: 10000,
}

var achievement_descriptions: Dictionary[Achievement, String] = {
	Achievement.MEET_FURO: "Meet Furo for the first time!",
	Achievement.USELESS_UPGRADE: "Upgrade your engine to a Better Engine!",
	Achievement.AN_EVEN_BETTER_ENGINE: "Upgrade your engine to an Exotic Engine!",
	Achievement.THE_BEST_ENGINE: "Upgrade your engine to a Stardust Engine!",
	Achievement.THE_FALLEN_ANGEL: "Defeat the Fallen Angel",
	Achievement.RICH_KID: "Earn %s coins in total!" % req_space_dollars[Achievement.RICH_KID],
	Achievement.THE_RICHEST_KID: "Earn %s coins in total!" % req_space_dollars[Achievement.THE_RICHEST_KID],
	Achievement.WEALTHY: "Earn %s coins in total!" % req_space_dollars[Achievement.WEALTHY],
	Achievement.HERE_COMES_THE_AIRPLANE: "Buy the Magma Spoon from Namazon!",
	Achievement.ALL_GOOD_THINGS_COME_IN_THREES: "Die three times by the hand of an Anime Girl!",
	Achievement.COLLECTOR: "Buy every item on Namazon!",
	Achievement.CLICKING_IS_FUN: "Click %s times in total!" % req_clicks[Achievement.CLICKING_IS_FUN],
	Achievement.ON_FIRE: "Click %s times in total!" % req_clicks[Achievement.ON_FIRE],
	Achievement.MY_FINGER_IS_TIRED: "Click %s times in total!" % req_clicks[Achievement.MY_FINGER_IS_TIRED],
	Achievement.NEWCOMER: "Spent 10 minutes in the Game!",
	Achievement.KNOWN: "Spent 1 hour in the Game!",
	Achievement.HOW: "Spent 10 hours in the Game!",
	Achievement.GODMODE: "Press G to activate God Mode for the first time!",
	Achievement.DUMMY: "Dummy Achievement",
}
