
--[[
Parameters:
On the Left side: the name of the song group to match
1st index: name of graphic to load in Graphics/_jackets/group and Graphics/_jackets/group/big jacket
2nd index: The color of the back of the song items, loaded in Graphics/_jackets/backing
3rd index: The name that's displayed on top of the gradient on the left above the music wheel
4th index: The color of the gradient and the outline of the text on the left above the music wheel. The outline is darkened, the gradient is the color used as is.

Q: I don't wanna make a graphic.
A: Too bad. Theme doesn't support folders without graphics right now.
]]

group_name = {
  ["DanceDanceRevolution 1stMIX"] = 		{"01 - DDR 1st","yellow green","Version/DDR 1st","#b4e556"};
  ["DanceDanceRevolution 2ndMIX"] = 		{"02 - DDR 2ndMIX","pink","Version/2ndMIX ","#eb8bc8"};
  ["DanceDanceRevolution 3rdMIX"] = 		{"03 - DDR 3rdMIX","yellow","Version/3rdMIX ","#fdf380" };
  ["DanceDanceRevolution 3rdMIX + VER.Korea"]={"03 - DDR 3rdMIX","yellow","Version/3rdMIX " };
  ["DanceDanceRevolution 4thMIX"] = 		{"04 - DDR 4thMIX","purple","Version/4thMIX ","#a592d5" };
  ["DanceDanceRevolution 5thMIX"] = 		{"05 - DDR 5thMIX","light blue","Version/5thMIX ","#12d0f2" };
  ["DanceDanceRevolution 6thMIX MAX"] = 	{"06 - DDR MAX","orange","Version/MAX ","#ffbe32"};
  ["DanceDanceRevolution 7thMIX MAX2"] =	{"07 - DDR MAX2","red","Version/MAX2 ","#fa4b3c"};
  ["DanceDanceRevolution 8thMIX EXTREME"] = {"08 - DDR EXTREME","green","Version/EXTREME ","#81f1a9"};
  ["DanceDanceRevolution SuperNOVA"] =		{"09 - DDR SuperNOVA","red","Version/SuperNOVA","#fa4b3c"};
  ["DanceDanceRevolution SuperNOVA2"] = 	{"10 - DDR SuperNOVA2","light blue","Version/SuperNOVA2","#12cff2"};
  ["DanceDanceRevolution X"] = 				{"11 - DDR X","orange","Version/X ","#ffbe32"};
  ["DanceDanceRevolution X2"] =				{"12 - DDR X2","pink","Version/X2 ","#eb8cc8"};
  ["DanceDanceRevolution X3"] =				{"13 - DDR X3 vs 2ndMIX","blue","Version/X3 vs 2ndMIX ","#16b5ef"};
  ["DanceDanceRevolution X3 vs 2ndMIX"] =	{"13 - DDR X3 vs 2ndMIX","blue","Version/X3 vs 2ndMIX ","#16b5ef"};
  ["DanceDanceRevolution X3 vs. 2ndMIX"] =  {"13 - DDR X3 vs 2ndMIX","blue","Version/X3 vs 2ndMIX ","#16b5ef"};
  ["DDR 2013"] = 							{"14 - DDR 2013","teal","Version/DDR 2013 ","#69ebca"};
  ["DDR 2014"] = 							{"15 - DDR 2014","teal","Version/DDR","#69ebca"};
  ["DDR 2014 and 2015"] = 					{"15 - DDR 2014","teal","Version/DDR","#69ebca"};
  ["DanceDanceRevolution A"] = 				{"16 - DDR A","light blue","Version/DDR A ","#16b5ef"};
  ["DanceDanceRevolution Ace"] = 			{"16 - DDR A","light blue","Version/DDR A ","#16b5ef"};
  ["DanceDanceRevolution A20"] = 			{"17 - DDR A20","orange","Version/DDR A20","#00a61c"};
  ["DanceDanceRevolution SuperNOVA3"] = 	{"18 - DDR SuperNOVA3","green","Version/SuperNOVA3","#81f1a9"};
  ["DanceDanceRevolution XX -Starlight-"] = {"19 - DDR XX","dark blue","Version/STARLiGHT","#001aff"};
  ["00 - BOSS ON PARADE"] = 				{"00 - BOSS ON PARADE","magenta","BOSS ON PARADE","#ae00ff"};
};


--TODO: Get rid of this
group_colors= {
	-- genre/bemani series sort
	["Pop"]= "#ffbe32",
	["Anime/Game"]=	"#fff582",
	["Variety"]= "#eb8cc8",
	["GUMI 5th anniversary"]=	"#b8e267",
	["U.M.U. x BEMANI"]= "#fbafb4",
	["KONAMI originals"]= "#fa4b3c",
	["beatmania IIDX"]="#0165ac",
	["pop'n music"]="#fff582",
	--["DanceDanceRevolution XX -Starlight-"]="#001aff",
}

--This is the color of the groups when you're not using the group sort order, since they're all the same color
sortorder_group_colors = {
	["SortOrder_Title"]= "#fff582",
	["SortOrder_AllDifficultyMeter"] ="#0167ae",
	["SortOrder_BPM"]="#69ebca",
	--["SortOrder_Popularity"]=
	["SortOrder_TopGrades"]="#7dff44"
}


