local SSA, Auras, _, _, LBG = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor
local gsub, tonumber, tostring = gsub, tonumber, tostring

-- Cache Global WoW API Functions
local GetSpecialization = GetSpecialization

-- Set the aura's opacity to the user-specified level when the player is out of combat.
function Auras:NoCombatDisplay(self,group)
	local spec = SSA.spec
	
	if (Auras.db.char.auras[spec].cooldowns.groups[group].isPreview or Auras.db.char.auras[spec].groups[group].isAdjust) then
		self:SetAlpha(1)
	else
		self:SetAlpha(Auras.db.char.settings[spec].OoCAlpha)
	end
	
	--[[if (self.glow) then
		if (self:GetName() == "MasterOfElements") then
			print("TURN OFF GLOW")
		end
		Auras:ToggleOverlayGlow(self.glow,false)
	else
		if (self:GetName() == "MasterOfElements") then
			print("WTF?!")
		end
	end]]
end

function Auras:GlowHandler(obj)
	local glow = Auras.db.char.auras[SSA.spec].auras[obj:GetName()].glow
	
	for i=1,#glow.triggers do
		local trigger = glow.triggers[i]
		
		if ((trigger.type == "cooldown" or trigger.type == "buff" or trigger.type == "debuff") and trigger.isEnabled and (obj.activePriority >= i  or obj.activePriority == 0)) then
			if (obj.activePriority ~= i) then
				obj.activePriority = i
			end
			
			if (trigger.combat == "all" or (trigger.combat == "on" and Auras:IsPlayerInCombat(true)) or (trigger.combat == "off" and not Auras:IsPlayerInCombat(true))) then
				if (trigger.show == "all" or (trigger.show == "on" and obj.duration > 1.5) or trigger.show == "off") then
					local expire = obj.start + obj.duration
					local remains = (expire) - GetTime()
					
					if (trigger.show ~= "on" and trigger.displayTime > 0) then
						SSA.DataFrame.text:SetText("WITH DISPLAY\n\nTime: "..GetTime().."\nExpire: "..expire.."\nDisplay: "..(expire + trigger.displayTime))
						if ((GetTime() < ((expire) + trigger.displayTime) and GetTime() > (expire)) or (trigger.show == "all" and remains <= trigger.threshold and remains > 0)) then
						--if ((GetTime() < ((expire) + v.displayTime) and GetTime() > (expire))) then
							--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."MEET DISPLAY TIME OR THRESHOLD NEEDS\n")
							--if (not obj.isGlowing) then
							--	obj.isGlowing = true
							if (trigger.pulseRate > 0 and GetTime() >= obj.pulseTime) then
								obj.pulseTime = GetTime() + trigger.pulseRate
								LBG.HideOverlayGlow(obj)
								LBG.ShowOverlayGlow(obj)
							end
							
							--obj.isTimeGlow = true
							Auras:ToggleOverlayGlow(obj,true)
							--end
						else
							--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."DOES NOT MEET DISPLAY TIME OR THRESHOLD NEEDS\n")
							--if (obj.isGlowing) then
							--	obj.isGlowing = false
							--obj.isTimeGlow = false
							Auras:ToggleOverlayGlow(obj,false)
							--end
						end
					elseif (trigger.show ~= "off" and remains <= trigger.threshold and remains > 0) then
						--if (not obj.isGlowing) then
						--	obj.isGlowing = true
						SSA.DataFrame.text:SetText("NO DISPLAY\n\nTime: "..GetTime().."\nExpire: "..expire.."\nDisplay: "..(expire + trigger.displayTime))
						if (trigger.pulseRate > 0 and GetTime() >= obj.pulseTime) then
							SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."PULSE\n")
							obj.pulseTime = GetTime() + trigger.pulseRate
							LBG.HideOverlayGlow(obj)
							LBG.ShowOverlayGlow(obj)
						end
						SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\nFILLER\n")
						--obj.isTimeGlow = true
						Auras:ToggleOverlayGlow(obj,true)
						--end
					else
						--if (obj.isGlowing) then
						--	obj.isGlowing = false
						--obj.isTimeGlow = false
							Auras:ToggleOverlayGlow(obj,false)
						--end
					end
				else
					--if (obj.isGlowing) then
					--	obj.isGlowing = false
					--obj.isTimeGlow = false
						Auras:ToggleOverlayGlow(obj,false)
					--end
				end
			else
				--if (obj.isGlowing) then
				--	obj.isGlowing = false
				--obj.isTimeGlow = false
					Auras:ToggleOverlayGlow(obj,false)
				--end
			end
		elseif (trigger.type == "charges" and trigger.isEnabled and (obj.activePriority >= i or obj.activePriority == 0)) then
			if (obj.activePriority ~= i) then
				obj.activePriority = i
			end
			
			if (trigger.combat == "all" or (trigger.combat == "on" and Auras:IsPlayerInCombat(true)) or (trigger.combat == "off" and not Auras:IsPlayerInCombat(true))) then
				if (obj.charges <= trigger.threshold and obj.charges > 0) then
					--if (not obj.isGlowing) then
					--	obj.isGlowing = true
					if (obj.triggerTime == 0 and not obj.isTriggered) then
						obj.triggerTime = GetTime()
					end
					SSA.DataFrame.text:SetText("Time: "..GetTime().."\nTrigger: "..obj.triggerTime.."\nDisplay: "..tostring(trigger.displayTime).."\nEnd: "..(obj.triggerTime + trigger.displayTime).."\nTriggered: "..tostring(obj.isTriggered))
					if (trigger.displayTime == 0 or (trigger.displayTime > 0 and GetTime() < (obj.triggerTime + trigger.displayTime) and GetTime() >= obj.triggerTime)) then
						
						if (trigger.pulseRate > 0 and GetTime() >= obj.pulseTime) then
							obj.pulseTime = GetTime() + trigger.pulseRate
							LBG.HideOverlayGlow(obj)
							LBG.ShowOverlayGlow(obj)
						end
						
						--obj.isChargeGlow = true
						
						if (not obj.isTriggered) then
							SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\n\nTriggering Glow\n")
							obj.isTriggered = true
							Auras:ToggleOverlayGlow(obj,true)
						end
					else
						SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\n\nHiding Glow\n")
						--obj.isChargeGlow = false
						Auras:ToggleOverlayGlow(obj,false)
					end
					--end
				else
					--if (obj.isGlowing) then
					--	obj.isGlowing = false
					--obj.isChargeGlow = false
						Auras:ToggleOverlayGlow(obj,false)
					--end
				end
			else
				--if (obj.isGlowing) then
				--	obj.isGlowing = false
				--obj.isChargeGlow = false
					Auras:ToggleOverlayGlow(obj,false)
				--end
			end
		end
	end
	
	--[[for k,v in pairs(glowTbl or glow.triggers) do
		
		if (type(v) == "table") then
			local key,val = next(v)
			
			if (type(val) ~= "table") then
				if ((k == "cooldown" or k == "buff" or k == "debuff") and v.isEnabled and not obj.isChargeGlow and (obj.activePriority >= v.priority or obj.activePriority == 0)) then
					if (obj.activePriority ~= v.priority) then
						obj.activePriority = v.priority
					end
				
					if (v.combat == "all" or (v.combat == "on" and Auras:IsPlayerInCombat(true)) or (v.combat == "off" and not Auras:IsPlayerInCombat(true))) then
						if (v.show == "all" or (v.show == "on" and obj.duration > 1.5) or v.show == "off") then
							local expire = obj.start + obj.duration
							local remains = (expire) - GetTime()
							--SSA.DataFrame.text:SetText("Remains: "..tostring(remains))
							
							-- if (v.displayTime > 0) then
								-- if (remains <= v.threshold and remains > 0
							-- else
							
							-- end
							
							
							
							
							
							if ((v.show == "all" or v.show == "off") and v.displayTime > 0) then
								
								
								SSA.DataFrame.text:SetText("WITH DISPLAY\n\nTime: "..GetTime().."\nExpire: "..expire.."\nDisplay: "..(expire + v.displayTime))
								if ((GetTime() < ((expire) + v.displayTime) and GetTime() > (expire)) or (v.show == "all" and remains <= v.threshold and remains > 0)) then
								--if ((GetTime() < ((expire) + v.displayTime) and GetTime() > (expire))) then
									--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."MEET DISPLAY TIME OR THRESHOLD NEEDS\n")
									--if (not obj.isGlowing) then
									--	obj.isGlowing = true
										if (v.pulseRate > 0 and GetTime() >= obj.pulseTime) then
											obj.pulseTime = GetTime() + v.pulseRate
											LBG.HideOverlayGlow(obj)
											LBG.ShowOverlayGlow(obj)
										end
										
										obj.isTimeGlow = true
										Auras:ToggleOverlayGlow(obj,true)
									--end
								else
									--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."DOES NOT MEET DISPLAY TIME OR THRESHOLD NEEDS\n")
									--if (obj.isGlowing) then
									--	obj.isGlowing = false
									obj.isTimeGlow = false
										Auras:ToggleOverlayGlow(obj,false)
									--end
								end
							elseif ((v.show == "all" or v.show == "on") and remains <= v.threshold and remains > 0) then
								--if (not obj.isGlowing) then
								--	obj.isGlowing = true
								SSA.DataFrame.text:SetText("NO DISPLAY\n\nTime: "..GetTime().."\nExpire: "..expire.."\nDisplay: "..(expire + v.displayTime))
								if (v.pulseRate > 0 and GetTime() >= obj.pulseTime) then
									SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."PULSE\n")
									obj.pulseTime = GetTime() + v.pulseRate
									LBG.HideOverlayGlow(obj)
									LBG.ShowOverlayGlow(obj)
								end
								SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\nFILLER\n")
								obj.isTimeGlow = true
								Auras:ToggleOverlayGlow(obj,true)
								--end
							else
								--if (obj.isGlowing) then
								--	obj.isGlowing = false
								obj.isTimeGlow = false
									Auras:ToggleOverlayGlow(obj,false)
								--end
							end
						else
							--if (obj.isGlowing) then
							--	obj.isGlowing = false
							obj.isTimeGlow = false
								Auras:ToggleOverlayGlow(obj,false)
							--end
						end
					else
						--if (obj.isGlowing) then
						--	obj.isGlowing = false
						obj.isTimeGlow = false
							Auras:ToggleOverlayGlow(obj,false)
						--end
					end
				elseif (k == "charges" and v.isEnabled and not obj.isTimeGlow and (obj.activePriority >= v.priority or obj.activePriority == 0)) then
					if (obj.activePriority ~= v.priority) then
						obj.activePriority = v.priority
					end
				
					if (v.combat == "all" or (v.combat == "on" and Auras:IsPlayerInCombat(true)) or (v.combat == "off" and not Auras:IsPlayerInCombat(true))) then
						if (obj.charges <= v.threshold and obj.charges > 0) then
							--if (not obj.isGlowing) then
							--	obj.isGlowing = true
							if (obj.triggerTime == 0 and not obj.isTriggered) then
								obj.triggerTime = GetTime()
							end
							SSA.DataFrame.text:SetText("Time: "..GetTime().."\nTrigger: "..obj.triggerTime.."\nDisplay: "..tostring(v.displayTime).."\nEnd: "..(obj.triggerTime + v.displayTime).."\nTriggered: "..tostring(obj.isTriggered))
							if (v.displayTime == 0 or (v.displayTime > 0 and GetTime() < (obj.triggerTime + v.displayTime) and GetTime() >= obj.triggerTime)) then
								
								if (v.pulseRate > 0 and GetTime() >= obj.pulseTime) then
									obj.pulseTime = GetTime() + v.pulseRate
									LBG.HideOverlayGlow(obj)
									LBG.ShowOverlayGlow(obj)
								end
								
								obj.isChargeGlow = true
								
								if (not obj.isTriggered) then
									SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\n\nTriggering Glow\n")
									obj.isTriggered = true
									Auras:ToggleOverlayGlow(obj,true)
								end
							else
								SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."\n\nHiding Glow\n")
								obj.isChargeGlow = false
								Auras:ToggleOverlayGlow(obj,false)
							end
							--end
						else
							--if (obj.isGlowing) then
							--	obj.isGlowing = false
							obj.isChargeGlow = false
								Auras:ToggleOverlayGlow(obj,false)
							--end
						end
					else
						--if (obj.isGlowing) then
						--	obj.isGlowing = false
						obj.isChargeGlow = false
							Auras:ToggleOverlayGlow(obj,false)
						--end
					end
				end
			else
				self:GlowHandler(obj,val)
			end
		end
	end]]
	
	--[[if (glow.isEnabled) then
		if (glow.triggers.selected == "time" or (glow.triggers.selected == "all" and glow.triggers.time)) then
			if (obj.duration > 1.5) then
				local remains = (obj.start + obj.duration) - GetTime()
				
				if (glow.states.combat == "both" or (glow.states.combat == "yes" and Auras:IsPlayerInCombat(true)) or (glow.states.combat == "not" and not Auras:IsPlayerInCombat(true))) then
					if (remains <= glow.triggers.time.threshold) then
						Auras:ToggleOverlayGlow(obj,true)
					else
						Auras:ToggleOverlayGlow(obj,false)
					end
				else
					Auras:ToggleOverlayGlow(obj,false)
				end
			end
		end
	else
		Auras:ToggleOverlayGlow(obj,false)
	end]]
end

-- Returns the current spec as well as group ID for the specified aura
--function Auras:GetAuraInfo(obj,debugHelper)
function Auras:GetAuraGroupID(obj,debugHelper)
	if (not obj) then
		SSA.DataFrame.text:SetText("ERROR: GetAurainfo()\nMESSAGE: NO OBJECT\nSOURCE: "..debugHelper)
	else
		local spec = SSA.spec
		--local spec,groupID = GetSpecialization()
		
		if (not Auras.db.char.auras[spec].auras[obj:GetName()]) then
			SSA.DataFrame.text:SetText("ERROR: GetAurainfo()\nMESSAGE: BAD INDEX\nSOURCE: "..debugHelper)
		else
			--groupID = Auras.db.char.auras[spec].auras[obj:GetName()].group
			return Auras.db.char.auras[spec].auras[obj:GetName()].group
		end
		
		--return spec,groupID
	end
end

function Auras:GetGroupID(category,spec,auraName)
	for k,v in pairs(Auras.db.char[category][spec]) do
		if (k == auraName) then
			return v.group
		end
	end
	--return tonumber(groupID)
end

function Auras:SortTimerBars(spec)
	local barsShowing = {}
	local db = Auras.db.char
	local timerbars = db.timerbars[spec]
	local direction = 1

	-- Collect timer bars that have a start time that's greater than 0
	for k,v in pairs(timerbars.bars) do
		local bar = SSA[k]
		if (bar.start > 0) then
			tinsert(barsShowing,bar.start)
		elseif (v.isAdjust) then
			--print("Inserting: "..k..";"..tostring(v.group))
			tinsert(barsShowing,k..";"..v.layout.group)
		end
	end
	
	table.sort(barsShowing)
	
	for i=1,#barsShowing do
		if (type(barsShowing[i]) == "number") then
			for k,v in pairs(timerbars.bars) do
				local bar = SSA[k]
				
				if (bar.start == barsShowing[i]) then
					local layout = timerbars.groups[v.layout.group].layout
					
					if (layout.growth == "RIGHT" or layout.growth == "UP") then
						direction = 1
					elseif (layout.growth == "LEFT" or layout.growth == "DOWN") then
						direction = -1
					end
		
					local offset = (((i - 1) * layout.spacing) + ((i - 1) * layout.height)) * direction
					
					if (k == "AncestralGuidanceBar") then
						print("Offset: "..tostring(offset))
					end
					SSA[k]:ClearAllPoints()
					
					if (layout.orientation == "VERTICAL") then
						SSA[k]:SetPoint("CENTER",offset,0)
					else
						SSA[k]:SetPoint("TOP",0,offset)
					end
				end
			end
		else
			local barName,barGroup = strsplit(";",barsShowing[i])
			--print("BAR GROUP: "..tostring(barInfo[1]).." ("..tostring(barsShowing[i])..")")
			local layout = timerbars.groups[tonumber(barGroup)].layout
					
			if (layout.growth == "RIGHT" or layout.growth == "UP") then
				direction = 1
			elseif (layout.growth == "LEFT" or layout.growth == "DOWN") then
				direction = -1
			end

			local offset = (((i - 1) * layout.spacing) + ((i - 1) * layout.height)) * direction

			SSA[barName]:ClearAllPoints()
			--SSA[barName]:SetPoint(layout.anchor,offset,0)
			if (layout.orientation == "VERTICAL") then
				SSA[barName]:SetPoint("CENTER",offset,0)
			else
				SSA[barName]:SetPoint("TOPLEFT",0,offset)
			end
		end
	end
end

local function RunTimer(bar,db,start,duration)
	local expire = start + duration
	local timer,seconds = Auras:parseTime(expire - GetTime(),true)
	
	bar:SetValue(seconds)
	bar.timetext:SetText(timer)
	
	Auras:SortTimerBars(SSA.spec)
	
	if (GetTime() >= expire) then
		db.startTime = 0
	end
end

local function PreviewTimerBar(bar,group,isAdjust)
	local spec = SSA.spec
	
	if (not bar.adjustExpireTime or GetTime() >= (bar.adjustExpireTime - 3)) then
		bar.adjustExpireTime = GetTime() + 10
	end
	
	local timer,seconds = Auras:parseTime(bar.adjustExpireTime - GetTime(),true)
	
	bar:SetMinMaxValues(0,10)
	bar:SetValue(seconds)
	if (not (bar.timetext)) then
		print("NO TIME TEXT: "..tostring(bar:GetName()))
	end
	bar.timetext:SetText(timer)
	
	if (isAdjust) then
		Auras:SortTimerBars(spec)
	else
		if (Auras.db.char.layout[spec].timerbars.groups[group].layout.orientation == "VERTICAL") then
			bar:SetPoint("CENTER",0,0)
		else
			bar:SetPoint("TOPLEFT",0,0)
		end
	end
end

local function HideTimerBar(bar)
	if (bar.adjustExpireTime) then
		bar.adjustExpireTime = nil
	end
	
	bar:Hide()
end

function Auras:RunTimerBarCode(bar)
	local timerbar = Auras.db.char.timerbars[SSA.spec].bars[bar:GetName()]
	
	local duration = bar.duration
	
	--[[if (timerbar.data.start > 0) then
		RunTimer(bar,timerbar,spec,timerbar.data.start,timerbar.data.duration)
	elseif ((timerbar.isAdjust or timerbar.isCustomize) and timerbar.isInUse) then
		PreviewTimerBar(bar,spec,timerbar.layout.group,timerbar.isAdjust)
	else
		HideTimerBar(bar)
	end]]
	local remains = (bar.start + bar.duration) - GetTime()
	
	if (remains > 0) then
		RunTimer(bar,timerbar,bar.start,duration)
	elseif ((timerbar.isAdjust or timerbar.isCustomize) and timerbar.isInUse) then
		PreviewTimerBar(bar,timerbar.layout.group,timerbar.isAdjust)
	elseif (remains <= 0) then
		bar.start = 0
		bar:Hide()
	end
end

function Auras:RunTimerEvent_Aura(bar,isAnyCaster,...)
	local timerbar = Auras.db.char.timerbars[SSA.spec].bars[bar:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = ...
	
	--[[if (spellID == 193796) then
		print("FLAMETONGUE BAR")
	end]]
	if (((not isAnyCaster and srcGUID == UnitGUID("player")) or (isAnyCaster and destGUID == UnitGUID("player"))) and bar.spellID == spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			local _,_,_,_,duration = AuraUtil.FindAuraByName(Auras:GetSpellName(spellID),"player")
			--timerbar.data.duration = duration
			--timerbar.data.start = GetTime()
			bar.duration = duration
			bar.start = GetTime()
			bar:SetMinMaxValues(0,duration)
			bar:Show()
		elseif (subevent == "SPELL_AURA_REMOVED") then
			--timerbar.data.start = 0
			bar.start = 0
		end
	end
end

function Auras:RunTimerEvent_Totem(bar,...)
	local timerbar = Auras.db.char.timerbars[SSA.spec].bars[bar:GetName()]
	local _,subevent,_,srcGUID,_,_,_,_,_,_,_,spellID = ...
	
	if (srcGUID == UnitGUID("player") and subevent == "SPELL_SUMMON" and bar.spellID == spellID) then
		--timerbar.data.start = floor(GetTime())
		bar.start = floor(GetTime())
		--timerbar.info.isActive = true
		--SSA.activeTotems[timerbar.startTime] = bar:GetName()
		--SSA.activeTotems[bar:GetName()] = timerbar.data.start
		SSA.activeTotems[bar:GetName()] = bar.start
		bar:Show()
	end
end

function Auras:RunTimerEvent_Elemental(bar,primalIDs,...)
	local timerbar = Auras.db.char.timerbars[SSA.spec].bars[bar:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (srcGUID == UnitGUID("player") and subevent == "SPELL_SUMMON") then
		-- If the player casts Primal Earth Elemental while the Primal Fire Elemental is already active,
		-- hide the timer bar for Primal Fire Elemental
		if (primalIDs and bar.start > 0) then
			if (type(primalIDs) == "table") then
				for i=1,#primalIDs do
					if (spellID == primalIDs[i]) then
						bar.start = 0
					end
				end
			elseif (spellID == primalIDs) then
				--timerbar.data.start = 0
				bar.start = 0
			end
			--timerbar.data.GUID = descGUID
			bar.GUID = descGUID
		elseif (spellID == timerbar.spellID) then
			-- Only Enhancement's "Feral Spirit" ability uses "lives"
			--[[if (timerbar.data.lives) then
				timerbar.data.lives = 2
			else
				timerbar.data.GUID = destGUID
			end]]
			if (bar.lives) then
				bar.lives = 2
			else
				bar.GUID = destGUID
			end

			--timerbar.data.start = floor(GetTime())
			bar.start = floor(GetTime())
			--SSA.activeTotems[timerbar.startTime] = bar:GetName()
			--SSA.activeTotems[bar:GetName()] = timerbar.data.start
			SSA.activeTotems[bar:GetName()] = bar.start
			bar:Show()
		end
	--elseif (subevent == "UNIT_DIED" and timerbar.data.lives) then
	elseif (subevent == "UNIT_DIED" and bar.lives) then
		--timerbar.data.lives = timerbar.data.lives - 1
		bar.lives = bar.lives - 1
		--[[if (timerbar.data.lives <= 0) then
			timerbar.data.start = 0
		end]]
		if (bar.lives <= 0) then
			bar.start = 0
		end
	--elseif (subevent == "UNIT_DIED" and destGUID == timerbar.data.GUID) then
	elseif (subevent == "UNIT_DIED" and destGUID == bar.GUID) then
		--timerbar.data.start = 0
		bar.start = 0
	end
end