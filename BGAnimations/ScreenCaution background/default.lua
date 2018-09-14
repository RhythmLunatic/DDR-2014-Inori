if THEME:GetCurLanguage() == "Japanese" then
	return Def.ActorFrame {
		LoadActor("JP_caution")..{
			OnCommand=cmd(FullScreen);
		};
	}
else
	return Def.ActorFrame {
		LoadActor("EN_caution")..{
			OnCommand=cmd(FullScreen);
		};
	}

end;