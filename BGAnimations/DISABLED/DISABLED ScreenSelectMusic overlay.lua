local musicwheel; --Need a handle on the MusicWheel to work around a StepMania bug. Also needed to get the folders.

--==========================
--Special folders... lua doesn't have enums so this is as close as it gets.
--==========================
local WHEELTYPE_NORMAL = 0
local WHEELTYPE_PREFERRED = 1
local WHEELTYPE_SORTORDER = 2
--Empty, won't appear but it takes up space
local WHEELTYPE_EMPTY = 3
--==========================
--Item Scroller. Must be defined at the top to have 'scroller' var accessible to the rest of the lua.
--==========================
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 15

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				
			Def.Sprite{
				Name="Backing";
				Texture=THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/Backing.png");
			};
			
			Def.Sprite{
				Name="Banner";
				InitCommand=cmd(scaletoclipped,128,128;addx,-4;addy,2;diffusealpha,0;);
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
			--[[Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100;DiffuseAndStroke,Color("White"),Color("Black");shadowlength,1);
			};]]
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		--self.container:hurrytweening(2);
		--self.container:finishtweening();
		--[[self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.45);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		--self.container:rotationy(offsetFromCenter*-45);
		self.container:zoom(math.cos(offsetFromCenter*math.pi/3)*.9):diffusealpha(math.cos(offsetFromCenter*math.pi/3)*.9);
		]]
		self.container:stoptweening()
		if math.abs(offsetFromCenter) < 6 then
			self.container:decelerate(.43);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x( offsetFromCenter*174 );
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		if info[1] == WHEELTYPE_EMPTY then
			self.container:GetChild("Banner"):visible(false)
			self.container:GetChild("Backing"):visible(false)
			return
		else
			self.container:GetChild("Banner"):visible(true)
			self.container:GetChild("Backing"):visible(true)
		end
	
		--self.container:GetChild("text"):settext(info);
		local so = GAMESTATE:GetSortOrder()
		
		--self.container:GetChild("Backing"):visible(info[1]==WHEELTYPE_NORMAL);
		self.container:GetChild("Banner"):visible(info[1]==WHEELTYPE_NORMAL);
		if info[1]==WHEELTYPE_NORMAL then
			self.container:GetChild("Backing"):Load(THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/Backing.png"));
			if so == "SortOrder_Group" then
				self.container:GetChild("Backing"):diffuse(color(group_colors[info[2]] or "#FFFFFF"))
			else
				self.container:GetChild("Backing"):diffuse(color(sortorder_group_colors[info[2]] or "#FFFFFF"))
			end;
			
			local group = info[2]
			local c = self.container:GetChild("Banner");
			if so == "SortOrder_Title" then
				if group ~= "" then
					c:Load(THEME:GetPathG("group title",group));
					c:diffusealpha(1);
				end;
			elseif so == "SortOrder_BPM" then
				local n = tonumber(split("-",group)[1]);
				if n == nil then
					c:Load( THEME:GetPathG("group bpm","NA"));
				elseif n < 1000 then
					c:Load(THEME:GetPathG("group bpm",tostring(n)));
				elseif n == 1000 then
					c:Load(THEME:GetPathG("group bpm","a1000"));
				else
					c:Load( THEME:GetPathG("group bpm","NA"));
				end;
				c:diffusealpha(1);
			elseif so == "SortOrder_TopGrades" then
				if group == "???" then
					c:Load(THEME:GetPathG("group cleared rank","unplayed"));
				else
					local t = split("x",string.gsub(group,"%s+",""))[1]
					if t == "" then
						c:Load(THEME:GetPathG("group cleared rank","unplayed"));
					else
						c:Load(THEME:GetPathG("group grade",t..".png"));
					end;
				end;
				c:diffusealpha(1);
			elseif so == "AllDifficultyMeter" then
				local n = tonumber(group)
				if n and n <= 20 then
					c:Load(THEME:GetPathG("group diff",group))
				else
					c:Load(THEME:GetPathG("group global","NA"));
				end;
				c:diffusealpha(1);
			else
				if group_name[group] ~= nil then
					c:Load( THEME:GetPathG("","_No banner") );
					c:diffusealpha(0);
				else
					local g = GetSongGroupJacketPath(group)
					if g then
						c:Load(g)
					else
						c:Load( THEME:GetPathG("","_No banner") );
					end;
					c:diffusealpha(1);
				end;
			end;
		elseif info[1] == WHEELTYPE_SORTORDER then
			--banner = THEME:GetPathG("Banner",info[3]);
			self.container:GetChild("Backing"):Load(THEME:GetPathG("","_jackets/sort/"..ToEnumShortString(info[3])))
		elseif info[1] == WHEELTYPE_PREFERRED then
			--Maybe it would be better to use info[3] and a graphic named CoopSongs.txt.png? I'm not sure.
			self.container:GetChild("Backing"):Load(THEME:GetPathG("Banner",info[2]));
		end;

		--[[if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("_no","banner"));
  		else
  			self.container:GetChild("banner"):Load(banner);
  			--self.container:GetChild("text"):visible(false);
		end;]]
		
		--self.container:GetChild("banner"):scaletofit(-500,-200,500,200);
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}

--==========================
--Calculate groups and such
--==========================
--local hearts = GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
groups = {};
--local shine_index = 1;
local names = SONGMAN:GetSongGroupNames()

selection = 1;
local spacing = 210;
--local numplayers = GAMESTATE:GetHumanPlayers();

--If the sort order is not default this will be overridden when the screen is on
local groups = {};
--SCREENMAN:SystemMessage(GAMESTATE:GetSortOrder())



--"Why does this screen take so fucking long to init?!" -Someone out there.
--Format is WHEELTYPE, name for audio and graphic (and folder name if preferred), sortorder or preferred sort file name.

function insertSpecialFolders()
	
	--Insert these... Somewhere.
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","AllDifficultyMeter"),			"SortOrder_AllDifficultyMeter"});
	--This should only show up in single player
	--[[if GAMESTATE:GetNumSidesJoined() == 1 then
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("ScreenSelectGroup","SortOrder_DoubleAllDifficultyMeter"),	"SortOrder_DoubleAllDifficultyMeter"});
	end]]
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","Title"), 						"SortOrder_Title"});
	--SM grading is stupid
	--table.insert(groups, 1, {WHEELTYPE_SORTORDER, "Sort By Top Grades", "SortOrder_TopGrades"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","Artist"),	"SortOrder_Artist"});
	table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","BPM"),		"SortOrder_BPM"});
	--table.insert(groups, 1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","Origin"),	"Origin"});
end;

function genDefaultGroups()
	groups = {};
	for i,group in ipairs(SONGMAN:GetSongGroupNames()) do
		groups[i] = {WHEELTYPE_NORMAL,group}
	end;
	
	--Only show in multiplayer, since there's no need to show it in singleplayer.
	--[[if GAMESTATE:GetNumSidesJoined() > 1 then
		table.insert(groups, 1, {WHEELTYPE_PREFERRED, "CO-OP Mode","CoopSongs.txt"})
	end;]]

	for i,pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if getenv(pname(pn).."HasAnyFavorites") then
			table.insert(groups, i, {WHEELTYPE_PREFERRED, pname(pn).." Favorites", "Favorites.txt"})
		end;
	end;
	
	insertSpecialFolders();
	
	if GAMESTATE:GetCurrentSong() then
		local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
		for key,value in pairs(groups) do
			if curGroup == value[2] then
				selection = key;
			end
		end;
		setenv("cur_group",groups[selection][2]);
	else
		--lua.ReportScriptError("The current song should have been set in ScreenSelectPlayMode!");
	end;
end;
function genSortOrderGroups()
	groups = {};
	for i,group in ipairs(musicwheel:GetCurrentSections()) do
		groups[i] = {WHEELTYPE_NORMAL,group}
	end;
	table.insert(groups, #groups+1, {WHEELTYPE_SORTORDER, THEME:GetString("SortOrder","Group"), "SortOrder_Group"});
	insertSpecialFolders();
end;


if (GAMESTATE:GetSortOrder() == nil or GAMESTATE:GetSortOrder() == "SortOrder_Group" or GAMESTATE:GetSortOrder() == "SortOrder_Preferred") then
	genDefaultGroups();
end;

--[[
num = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetCurrentIndex()+1;
total = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetNumItems();
]]

local num, total

--=======================================================
--Input handler. Brought to you by PIU Delta NEX Rebirth.
--=======================================================
local button_history = {"none", "none", "none", "none"};
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	--if not pn or not SCREENMAN:get_input_redirected(pn) then return end
	if not pn then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		if groups[selection][1] == WHEELTYPE_SORTORDER then
			MESSAGEMAN:Broadcast("SortChanged",{newSort=groups[selection][3]})
			--Spin the groups cuz it will look cool.
			--It doesn't work..
			--SCREENMAN:SystemMessage("Test!");
			scroller:run_anonymous_function(function(self, info)
				self.container:stoptweening():linear(.3):rotationy(360):sleep(0):rotationy(0);
			end)
		else
			--SCREENMAN:set_input_redirected(PLAYER_1, false);
			--SCREENMAN:set_input_redirected(PLAYER_2, false);
			--MESSAGEMAN:Broadcast("StartSelectingSong");
			if groups[selection][1] == WHEELTYPE_PREFERRED then
				setSort("SortOrder_Preferred")
				SONGMAN:SetPreferredSongs(groups[selection][3]);
				self:load(THEME:GetPathS("","Genre/"..groups[selection][2]));
				musicwheel:SetOpenSection(groups[selection][2]);
			else
				if GAMESTATE:GetSortOrder() == "SortOrder_Preferred" then
					setSort("SortOrder_Group")
					--MESSAGEMAN:Broadcast("StartSelectingSong");
					-- Odd, changing the sort order requires us to call SetOpenSection more than once
					musicwheel:ChangeSort(sort);
					musicwheel:SetOpenSection(groups[selection][2]);
				end;
				musicwheel:SetOpenSection(groups[selection][2]);
				
				total = musicwheel:GetNumItems();
				if GAMESTATE:GetSortOrder() == "SortOrder_Group" then
					genDefaultGroups()
				else
					genSortOrderGroups();
				end;
				for i=1,total do
					table.insert(groups, selection+1, {WHEELTYPE_EMPTY});
				end;
				--local tempSelection = selection
				scroller:set_info_set(groups, 1);
				--[[scroller:run_anonymous_function(function(self, info)
					self.container:finishtweening()
				end)]]
				scroller:scroll_by_amount(selection-1)
				scroller.container:finishtweening();
			end;
			SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.1 );
			
			
		end;
	elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if selection == 1 then
			selection = #groups;
		else
			selection = selection - 1 ;
		end;
		scroller:scroll_by_amount(-1);
		setenv("cur_group",groups[selection][2]);
		MESSAGEMAN:Broadcast("GroupChange");
		
	elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if scroller:get_info_at_offset_from_current(1) and scroller:get_info_at_offset_from_current(1)[1] == WHEELTYPE_EMPTY then
			SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);
			--SCREENMAN:SystemMessage("Selecitng sogn");
		end;
		if selection == #groups then
			selection = 1;
		else
			selection = selection + 1
		end
		scroller:scroll_by_amount(1);
		setenv("cur_group",groups[selection][2]);
		MESSAGEMAN:Broadcast("GroupChange");
	--elseif button == "UpLeft" or button == "UpRight" then
		--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
	
	elseif button == "Back" then
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	elseif button == "MenuDown" then
		--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
		local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
		SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
		
		--local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	else
		--SCREENMAN:SystemMessage(strArrayToString(button_history));
		--musicwheel:SetOpenSection("");
		--SCREENMAN:SystemMessage(musicwheel:GetNumItems());
		--[[local wheelFolders = {};
		for i = 1,7,1 do
			wheelFolders[#wheelFolders+1] = musicwheel:GetWheelItem(i):GetText();
		end;
		SCREENMAN:SystemMessage(strArrayToString(wheelFolders));]]
		--SCREENMAN:SystemMessage(musicwheel:GetWheelItem(0):GetText());
	end;
	
end;

local isPickingDifficulty = false;
local t = Def.ActorFrame{
	
	--InitCommand=cmd(diffusealpha,0);
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		if (GAMESTATE:GetSortOrder() == nil or GAMESTATE:GetSortOrder() == "SortOrder_Group" or GAMESTATE:GetSortOrder() == "SortOrder_Preferred") then
			scroller:set_info_set(groups, 1);
		else
			genSortOrderGroups();
			local curGroup = musicwheel:GetSelectedSection();
			--SCREENMAN:SystemMessage(curGroup);
			for key,value in pairs(groups) do
				if curGroup == value[2] then
					selection = key;
				end
			end;
			assert(groups,"REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
			setenv("cur_group",groups[selection][2]);
			scroller:set_info_set(groups, 1);
		end;
		scroller:scroll_by_amount(selection-1)
	end;

	SongChosenMessageCommand=function(self)
		isPickingDifficulty = true;
	end;
	TwoPartConfirmCanceledMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	SongUnchosenMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	
	PickingSongCommand=function(self)
		isPickingDifficulty = false;
	end;
	
	CodeMessageCommand=function(self,param)
		local codeName = param.Name		-- code name, matches the one in metrics
		--player is not needed
		--local pn = param.PlayerNumber	-- which player entered the code
		--if codeName == "GroupSelectPad1" or codeName == "GroupSelectPad2" or codeName == "GroupSelectButton1" or codeName == "GroupSelectButton2" then
		if codeName == "Test" then
		if isPickingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
			MESSAGEMAN:Broadcast("StartSelectingGroup");
			--SCREENMAN:SystemMessage("Group select opened.");
			--No need to check if both players are present... Probably.
			SCREENMAN:set_input_redirected(PLAYER_1, true);
			SCREENMAN:set_input_redirected(PLAYER_2, true);
			musicwheel:Move(0);
		else
			--Debugging only
			--SCREENMAN:SystemMessage(codeName);
		end;
	end;
	
	StartSelectingGroupMessageCommand=function(self,params)
		local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		--curItem.container:GetChild("banner"):stoptweening():scaletofit(-500,-200,500,200);
		--self:stoptweening():linear(.5):diffusealpha(1);
		SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;

	--[[StartSelectingSongMessageCommand=function(self)
		self:linear(.3):diffusealpha(0);
		scroller:get_actor_item_at_focus_pos().container:GetChild("banner"):linear(.3):zoom(0);
	end;]]
	
	--Why is this even here? It could be in the above function...
	SortChangedMessageCommand=function(self,params)
		--Reset button history when the sort selection screen closes.
		--button_history = {"none", "none", "none", "none"};
	
		if musicwheel:ChangeSort(params.newSort) then
			if GAMESTATE:GetSortOrder() == "SortOrder_Group" then
				genDefaultGroups();
			else
				genSortOrderGroups();
			end;
			selection = 1
			--SCREENMAN:SystemMessage("SortChanged")
			scroller:set_info_set(groups, 1);
			setenv("cur_group",groups[selection][2]);
			--scroller:set_info_set({"aaa","bbb","ccc","ddd"},1);
			--Update the text that says the current group.
			MESSAGEMAN:Broadcast("GroupChange");
		end;
	end;
}


--Add scroller here
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

return t;
