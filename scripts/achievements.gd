extends Node

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
	DUMMY,
}


enum HiddenAchievement {
	ALL_BEGINNINGS_ARE_HARD, # die in your first battle
	HOLY_ICE_CREAM, # get a holy ice cream
	VERY_EXOTIC, # mine an exotic matter ore
	DUMMY,
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
