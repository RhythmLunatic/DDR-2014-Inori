local sBannerPath = THEME:GetPathG("Common", "fallback jacket");
local sJacketPath = THEME:GetPathG("Common", "fallback jacket");
local bAllowJackets = true
local song;
local group;
local getOn = 0;
local getOff = 0;

centerObjectProxy = nil;

--main backing
local t = Def.ActorFrame {
	--[[SetCommand=function(self,params)
		local song = params.Song
		local index = params.DrawIndex
		if song then
			if getOn == 0 then
				if index == 8 then
					self:zoom(0):decelerate(0.2):zoom(1)
				elseif index < 8 then
					self:addx(-SCREEN_WIDTH):decelerate(0.2):addx(SCREEN_WIDTH)
				elseif index > 8 then
					self:addx(SCREEN_WIDTH):decelerate(0.2):addx(-SCREEN_WIDTH)
				end;
			end;
		end;
		self:queuecommand("SetOn");
	end;
	SetOnCommand=function(self)
		getOn = 1;
	end;]]--
	Def.Sprite {
		OnCommand=function(self)
			self:diffusealpha(1):setsize(174,210)
			self:y(-2)
		end;
		SetMessageCommand=function(self,params)
		group = string.gsub(params.Text,"^%d%d? ?%- ?", "");
		local so = GAMESTATE:GetSortOrder();
			if group then
				if group_name[group] then
					self:Load(THEME:GetPathG("","_jackets/backing/full/"..group_name[group][2]..".png"))

					self:diffusealpha(1):setsize(174,210):diffuse(color("#FFFFFF"))
					self:y(-2)
				else
					self:Load(THEME:GetPathG("","MusicWheelItem Song NormalPart/Backing.png"));
					local so = GAMESTATE:GetSortOrder();
					if so == "SortOrder_Title" or so == "SortOrder_Artist" then
						self:diffuse(color("#fff582"));
					elseif so == "SortOrder_AllDifficultyMeter" then
						self:diffuse(color("#0167ae"));
					elseif so == "SortOrder_BPM" then
						self:diffuse(color("#69ebca"));
					elseif so == "SortOrder_Popularity" then
						self:diffuse(color("#b679fd"));
					elseif so == "SortOrder_TopGrades" then
						self:diffuse(color("#7dff44"));	
					elseif so == "SortOrder_Genre" then
						--TODO: use group_colors
						if group == "Pop" then
							self:diffuse(color("#ffbe32"));
						elseif group == "Anime/Game" then
							self:diffuse(color("#fff582"));
						elseif group == "Variety" then
							self:diffuse(color("#eb8cc8"));
						elseif group == "GUMI 5th anniversary" then
							self:diffuse(color("#b8e267"));
						elseif group == "U.M.U. x BEMANI" then
							self:diffuse(color("#fbafb4"));
						elseif group == "KONAMI originals" then
							self:diffuse(color("#fa4b3c"));
						elseif group == "beatmania IIDX" then
							self:diffuse(color("#0165ac"));
						elseif group == "pop'n music" then
							self:diffuse(color("#fff582"));
						elseif group == "GITADORA" then
							self:diffuse(color("#a592d5"));
						elseif group == "jubeat" then
							self:diffuse(color("#f1f5fb"));
						elseif group == "REFLEC BEAT" then
							self:diffuse(color("#81f1a9"));
						elseif group == "DanceEvolution" then
							self:diffuse(color("#12d0f2"));
						elseif group == "SOUND VOLTEX" then
							self:diffuse(color("#eb8cc8"));
						elseif group == "FutureTomTom" then
							self:diffuse(color("#fff582"));	
						elseif group == "DDR" then
							self:diffuse(color("#43ff9d"));
						else 
							self:diffuse(color("#ffffff"));					
						end;
					else
						--self:diffuse(color(color_grp))
						self:diffuse(color("White"));
						self:diffusealpha(1)
					end;
					self:y(-2):setsize(174,210)
					self:diffusealpha(1);
				end;
			end;
		end;
	};
--border default
LoadActor("title")..{
	InitCommand=function(self)
		self:y(-20)
	end;
};
Def.Sprite{
	InitCommand=cmd(scaletoclipped,140,140);
	SetMessageCommand=function(self,params)
	local song = params.Song;
	local pssp1 = STATSMAN:GetCurStageStats(params.Song):GetPlayerStageStats("PlayerNumber_P1")
	local staw1 = STATSMAN:GetCurStageStats(params.Song):GetPlayerStageStats("PlayerNumber_P1"):GetStageAward();
	local pssp2 = STATSMAN:GetCurStageStats(params.Song):GetPlayerStageStats("PlayerNumber_P2")
		if song then
			if not PROFILEMAN:IsSongNew(params.Song) then
			self:Load(THEME:GetPathG("MusicWheelItem Song","NormalPart/Borders/cleared.png"));
			self:diffusealpha(1);
			self:draworder(1);
			else
			self:diffusealpha(0);
			end;
		end;
	end;
};
--title part
	Def.BitmapText{
		Font="_@dfgW7 36px";
		InitCommand=cmd(zoom,0.7;maxwidth,140/0.7;wrapwidthpixels,2^24);
		SetMessageCommand=function(self, param)
			local Song = param.Song;
			local Course = param.Course;
			if Song then
				self:y(86)
				self:settext(Song:GetDisplayMainTitle());
				self:diffuse(color("#FFFFFF"));
			end
		end;
	};
Def.Quad {
	InitCommand=cmd(setsize,130,130;diffuse,color("#000000"));
};
--banner
	Def.Sprite {
		Name="Banner";
		InitCommand=cmd(scaletoclipped,128,128);
		--[[BannerCommand=cmd(scaletoclipped,128,128);
		JacketCommand=cmd(scaletoclipped,128,128);]]
		SetMessageCommand=function(self,params)
			local Song = params.Song;
			local Course = params.Course;
			if Song then
				if params.HasFocus then
					centerObjectProxy = self;
				end;
				if ( Song:GetJacketPath() ~=  nil ) and ( bAllowJackets ) then
					self:Load( Song:GetJacketPath() );
					--self:playcommand("Jacket");
				elseif ( Song:GetBackgroundPath() ~= nil ) and ( bAllowJackets ) then
					self:Load( Song:GetBackgroundPath() );
					--self:playcommand("Jacket");
				elseif ( Song:GetBannerPath() ~= nil ) then
					self:Load( Song:GetBannerPath() );
					--self:playcommand("Banner");
				else
				  self:Load( bAllowJackets and sBannerPath or sJacketPath );
				  --self:playcommand( bAllowJackets and "Jacket" or "Banner" );
				end;
			elseif Course then
				if ( Course:GetBackgroundPath() ~= nil ) and ( bAllowJackets ) then
					self:Load( Course:GetBackgroundPath() );
					--self:playcommand("Jacket");
				elseif ( Course:GetBannerPath() ~= nil ) then
					self:Load( Course:GetBannerPath() );
					--self:playcommand("Banner");
				else
					self:Load( sJacketPath );
					--self:playcommand( bAllowJackets and "Jacket" or "Banner" );
				end
			else
				self:Load( bAllowJackets and sJacketPath or sBannerPath );
				--self:playcommand( bAllowJackets and "Jacket" or "Banner" );
			end;
		end;
	};
--new song
	LoadActor("NEW") .. {
		InitCommand=cmd(y,-84;finishtweening;draworder,1;zoom,1;bob;effectmagnitude,0,5,0);
		SetCommand=function(self,param)
			if param.Song then
				if PROFILEMAN:IsSongNew(param.Song) then
					self:visible(true);
				else
					self:visible(false);
				end
			else
				self:visible(false);
			end
		end;
	};
};

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = LoadActor("diff.lua",PLAYER_1)..{
		InitCommand=cmd(xy,-61,-85);
	}
end;

if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	t[#t+1] = LoadActor("diff.lua",PLAYER_2)..{
		InitCommand=cmd(xy,61,-85);
	}
end;

return t;
