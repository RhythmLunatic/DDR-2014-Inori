-- Handles version sorts
SortExtra = function()
	SONGMAN:SetPreferredSongs("Extra")
	return "sort,Preferred";
end

SortBPM = function()
	SCREENMAN:GetTopScreen():GetChild('MusicWheel'):ChangeSort(3)
	return "sort,BPM"
end;

SortBemani = function()
	SONGMAN:SetPreferredSongs("Bemani")
	SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort("SortOrder_Preferred")
	return "sort,Preferred";
end;
