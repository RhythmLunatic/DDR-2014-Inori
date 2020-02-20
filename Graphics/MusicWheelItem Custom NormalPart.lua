return Def.ActorFrame {

	--Def.Quad{ InitCommand=cmd(diffuse,Color("Red");setsize,200,200); };
	Def.Sprite{
		--Not sure why but the sort graphics and the folder graphics are a bit misaligned, so this aligns them
		--InitCommand=cmd(y,2);

		--InitCommand=cmd(setsize,174,210;y,-2);
		--params.Label is set from en.ini MusicWheel
		SetMessageCommand=function(self,params)
			if params.Label and params.Label ~= "" then
				--SCREENMAN:SystemMessage(params.Label)
				if params.HasFocus then
					setenv("getgroupname",params.Label);
				end;
				self:Load( THEME:GetPathG("","_jackets/sort/"..params.Label) );
				--self:setsize(174,210)
			end;
		end;
	};
	
	--[[Def.Sprite{
		Texture=THEME:GetPathG("","_jackets/sort/Bemani");
	};]]
};
