local so;
local song;
local group;

local expanded = false;
local backingSprite = THEME:GetPathG("","MusicWheelItem SectionsCombined/ClosedBacking.png")
local firstRun = true;

local t = Def.ActorFrame{

	--[[OnCommand=function(self)
		--In the MusicWheelItem.cpp source code... m_sprNormalPart[i]->SetName( MusicWheelItemTypeToString(i)+"NormalPart" );
		if self:GetName() == "SectionExpandedNormalPart" then
			expanded = true;
			backingSprite = THEME:GetPathG("","MusicWheelItem SectionsCombined/OpenBacking.png")
		end;
	end;]]
	SetMessageCommand=function(self,params)
		if firstRun then
			if self:GetName() == "SectionExpandedNormalPart" then
				expanded = true;
				backingSprite = THEME:GetPathG("","MusicWheelItem SectionsCombined/OpenBacking.png")
			end;
			firstRun = false;
		end;
		song = params.Song;
		so = GAMESTATE:GetSortOrder();
		if so and so == "SortOrder_Group" then
			group = string.gsub(params.Text,"^%d%d? ?%- ?", "");
		else
			group = params.Text;
		end;
		--Does not work
		--self:playcommandonchildren("Update");
		--[[for i,a in ipairs(self:GetChildren()) do
			--a:playcommand("Update");
			SCREENMAN:SystemMessage(a:GetName());
			--i:GetName
		end;]]
		--self:GetChildren()[1]:playcommand("Update");
		--SCREENMAN:SystemMessage(#self:GetChildren())
		
		--This is beyond stupid
		if group then
			if params.HasFocus then
				setenv("getgroupname",params.Label);
			end;
			self:GetChild("Backing"):playcommand("Update");
			self:GetChild("SongBanner"):playcommand("Update");
			self:GetChild("Title"):playcommand("Update");
			self:GetChild("TitleLeftOutline"):playcommand("Update");
			self:GetChild("TitleLeft"):playcommand("Update");
		end;
	end;



	--group backing
	Def.Sprite {
		Name="Backing";
		UpdateCommand=function(self)
			--SCREENMAN:SystemMessage("asdasda");
			if group then
				--SCREENMAN:SystemMessage(group)
				if group_name[group] ~= nil and group_name[group][1] then
					local filePath = THEME:GetPathG("","_jackets/group/"..group_name[group][1]..".png");
					self:Load(filePath):diffuse(color("#FFFFFF"))
					self:diffusealpha(1);
					self:y(-2)
				else
					self:Load(backingSprite);
					self:y(-2)
					self:diffusealpha(1):setsize(174,210)
					if so == "SortOrder_Title" then
						local so = GAMESTATE:GetSortOrder();
						self:diffuse(color("#fff582"));
						--self:Load(THEME:GetPathG("group name","Alphabet"));
					elseif so == "SortOrder_AllDifficultyMeter" then
						self:diffusealpha(1);
						self:diffuse(color("#0167ae"));
					elseif so == "SortOrder_BPM" then
						self:diffusealpha(1);
						self:diffuse(color("#69ebca"));
					elseif so == "SortOrder_Popularity" then
						self:diffusealpha(1);
						self:Load(THEME:GetPathG("group name","Popularity"));
					elseif so == "SortOrder_TopGrades" then
						self:diffusealpha(1);
						self:diffuse(color("#7dff44"));
					else
						local color_grp= group_colors[group] or "#FFFFFF"
						self:diffuse(color(color_grp));
					end;
				end;
				
			end;
		end;
	};
	
	--Hide the group backing thing with "_extend" graphics
	Def.Sprite {
		SetMessageCommand=function(self,params)
			if not expanded then return end;
			if group then
				if group_name[group] then
					local filePath = THEME:GetPathG("","_jackets/group/_extend/"..group_name[group][2]..".png");
					self:Load(filePath)
					self:diffusealpha(1);
					self:y(-2)
					self:x(74);
				else
					self:diffusealpha(0);
				end;
				
			end;
		end;
	};

	--Shadow
	--[[Def.Quad{
		InitCommand=cmd(scaletoclipped,128,138;addx,-4;addy,10;diffusealpha,0;diffuse,color("0,0,0,1"));
		SetMessageCommand=function(self,params)
				group = params.Text;
		if group then
			if not group_name[group] then
				self:diffusealpha(1);
				--self:fadebottom(0.75)
			else
				self:diffusealpha(0);
			end;
		else
			-- call fallback
			self:diffusealpha(0.5);
		end;

	end;
	};]]
	Def.Sprite{
		Texture="shadow";
		InitCommand=cmd(scaletoclipped,138,140;addx,-9;addy,10;diffusealpha,0;diffuse,color("0,0,0,1"));
		SetMessageCommand=function(self,params)
			if group and so == "SortOrder_Group" then
				self:visible(not group_name[group])
			else
				self:visible(false)
			end
		end
	};
	
	
	--Jacket (or other object to put in the center)
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,128,128;addx,-9;addy,2;diffusealpha,0;);
		UpdateCommand=function(self)
			if group then
				if so == "SortOrder_Title" then
					if group ~= "Other" then
						self:Load(THEME:GetPathG("group title",group..".png"));
					else
						self:Load(THEME:GetPathG("group title","0-9.png"));
					end;
					self:diffusealpha(1);
				elseif so == "SortOrder_BPM" then
					local n = tonumber(split("-",group)[1]);
					if n == nil then
						self:Load( THEME:GetPathG("group bpm","NA"));
					elseif n < 1000 then
						self:Load(THEME:GetPathG("group bpm",tostring(n)));
					elseif n == 1000 then
						self:Load(THEME:GetPathG("group bpm","a1000"));
					else
						self:Load( THEME:GetPathG("group bpm","NA"));
					end;
					self:diffusealpha(1);
				elseif so == "SortOrder_TopGrades" then
					if group == "???" then
						self:Load(THEME:GetPathG("group cleared rank","unplayed"));
					else
						local t = split("x",string.gsub(group,"%s+",""))[1]
						if t == "" then
							self:Load(THEME:GetPathG("group cleared rank","unplayed"));
						else
							self:Load(THEME:GetPathG("group grade",t..".png"));
						end;
					end;
					self:diffusealpha(1);
					
				elseif so == "SortOrder_AllDifficultyMeter" then
					local n = tonumber(group)
					if n and n <= 20 then
						self:Load(THEME:GetPathG("group diff",group))
					else
						self:Load(THEME:GetPathG("group global","NA"));
					end;
					self:diffusealpha(1);
				else
					if group_name[group] ~= nil then
						self:Load( THEME:GetPathG("","_No banner") );
						self:diffusealpha(0);
					else
						local g = GetSongGroupJacketPath(group)
						if g then
							self:Load(g)
						else
							self:LoadFromSongGroup(group);
						end;
						self:diffusealpha(1);
					end;
				end;
			else
				-- call fallback
				self:Load( THEME:GetPathG("","_No banner") );
				self:diffusealpha(1);
			end;

		end;
	};
	--Titles
	Def.Sprite {
		Name="Title";
		InitCommand=cmd(addx,-7;addy,-80;zoom,.7);
		UpdateCommand=function(self)
			if group then
				if so == "SortOrder_Title" then
					self:visible(true);
					self:Load(THEME:GetPathG("group name","Alphabet"));
				elseif so == "SortOrder_AllDifficultyMeter" then
					self:visible(true);
					self:Load(THEME:GetPathG("group name","Dance Level"));
				elseif so == "SortOrder_BPM" then
					self:visible(true);
					self:Load(THEME:GetPathG("group name","BPM"));
				elseif so == "SortOrder_Popularity" then
					self:visible(true);
					self:Load(THEME:GetPathG("group name","Popularity"));
				elseif so == "SortOrder_TopGrades" then
					self:visible(true);
					self:Load(THEME:GetPathG("group name","Cleared Rank"));
				elseif so == "SortOrder_Genre" then
					self:visible(false);
					--genre sort
				elseif so == "SortOrder_Group" or so == "SortOrder_Preferred" then
					self:visible(false);
				end;
			end;
		};
	LoadFont("_itc avant garde std bk 20px")..{
		Name="TitleLeftOutline";
		InitCommand=cmd(y,-84;addx,-6;maxwidth,150);
		UpdateCommand=function(self)
			if so == "SortOrder_Group" then
				if group_name[group] then
					self:settext("");
				else
					self:settext(group);
					self:strokecolor(color("#000000"))
					self:diffuse(color("#000000"));
				end;
			elseif so == "SortOrder_TopGrades" then
				--self:settext(group);
				self:settext("");
			else
				self:settext("");
			end;
		end;
	};
	LoadFont("_itc avant garde std bk 20px")..{
		Name="TitleLeft";
		InitCommand=cmd(y,-86;addx,-6;maxwidth,150);
		UpdateCommand=function(self)
			if so == "SortOrder_Group" then
				
				if group_name[group] then
					self:settext("");
				else
					self:settext(group);
					self:strokecolor(color("#000000"))
					self:diffuse(color("#FFFFFF"));
				end;
			else
				self:settext("");
			end;
		end;
	};
};
return t;
