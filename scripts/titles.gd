extends Node

enum Title {
	NOOB,
	FALLEN_ANGEL_DESTROYER,
	MR_ORANGE,
}


enum HiddenTitle {
	EXOTIC,
	ICE_CREAM_HERO,
}


var title_names: Dictionary[Title, String] = {
	Title.NOOB: "Noob",
	Title.FALLEN_ANGEL_DESTROYER: "Fallen Angel Destroyer",
	Title.MR_ORANGE: "Mr. Orange's Lapdog",
}

var hidden_title_names: Dictionary[HiddenTitle, String] = {
	HiddenTitle.EXOTIC: "Exotic",
	HiddenTitle.ICE_CREAM_HERO: "Ice Cream Hero",
}

var title_descriptions: Dictionary[Title, String] = {
	Title.NOOB: "Be here.",
	Title.FALLEN_ANGEL_DESTROYER: "Defeat the Fallen Angel.",
	Title.MR_ORANGE: "Mine Antimatter for Mr. Orange.",
}

var hidden_title_descriptions: Dictionary[HiddenTitle, String] = {
	HiddenTitle.EXOTIC: "Mine exotic matter.",
	HiddenTitle.ICE_CREAM_HERO: "Find some Ice Cream!",
}
