local SSA, Auras, _, _, LBG = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor
local gsub, tonumber, tostring = gsub, tonumber, tostring
local twipe = table.wipe

-- Cache Global WoW API Functions
local GetSpecialization = GetSpecialization

-- Set the aura's opacity to the user-specified level when the player is out of combat.
function Auras:NoCombatDisplay(self,group)
	local spec = SSA.spec or GetSpecialization()
	
	if (not Auras.db.char.auras[spec].cooldowns.groups[group]) then
		--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."BAD COMBAT: "..tostring(self:GetName()).."\n")
	end
	
	if (Auras.db.char.auras[spec].cooldowns.groups[group].isPreview or Auras.db.char.auras[spec].groups[group].isAdjust) then
		self:SetAlpha(1)
	else
		self:SetAlpha(Auras.db.char.settings[spec].OoCAlpha)
	end
end

function Auras:SetGlowStartTime(obj,start,duration,spellID,triggerType)
	local glow = Auras.db.char.auras[SSA.spec].auras[obj:GetName()].glow
	
	--if ((duration or 0) > 1.5) then
	for i=1,#glow.triggers do
		local trigger = glow.triggers[i]
		
		if (trigger.isEnabled) then
			if ((trigger.spellID or 0) == spellID and trigger.type == triggerType) then	
				
				if ((duration or 0) > 1.5) then
					if (obj:GetName() == "HealingStreamTotem") then
						if ((duration or 0) > 0) then
							--print("Duration: "..tostring(duration))
						end
					end
					if (trigger.start == 0) then
						trigger.start = start
					end
				else
					if (trigger.start > 0) then
						if (obj:GetName() == "HealingStreamTotem") then
							--print("Start above 0")
						end
						if ((trigger.displayTime or 0) > 0) then
							local expire = trigger.start + trigger.duration
							--print(floor(GetTime()).." - "..tostring(floor(expire + trigger.displayTime)))
							if (GetTime() > (expire + trigger.displayTime)) then
								
								trigger.start = 0
							end
						else
							trigger.start = 0
						end
					else
						if (obj:GetName() == "HealingStreamTotem") then
							--print("Start 0")
						end
					end
				end
			end
		end
	end
	--end
end



function Auras:GlowHandler(obj)
	local glow = Auras.db.char.auras[SSA.spec].auras[obj:GetName()].glow
	
	for i=1,#glow.triggers do
		local trigger = glow.triggers[i]

		-- Check the type of trigger
		if ((trigger.type == "cooldown" or trigger.type == "buff" or trigger.type == "debuff")) then
			-- Check if the trigger is enabled
			if (trigger.isEnabled) then
				if ((trigger.target.reaction == "enemy" and Auras:IsTargetEnemy()) or (trigger.target.reaction == "friend" and not Auras:IsTargetEnemy()) or (trigger.target.reaction == "all" and UnitExists("target")) or (trigger.target.reaction == "off")) then
					local expire = trigger.start + (trigger.duration or 0)
					local remains = expire - GetTime()

					if (obj:GetName() == "FlameShock") then
						SSA.DataFrame.text:SetText(GetTime().."\n"..trigger.start.." + "..trigger.duration.." = "..expire.."\n"..remains)
					end
					-- Check if the trigger's combat conditions are met
					if (trigger.combat == "all" or (trigger.combat == "on" and Auras:IsPlayerInCombat(true)) or (trigger.combat == "off" and not Auras:IsPlayerInCombat(true))) then
						-- Check if the trigger's "show" and threshold conditons are met
						--if ((not trigger.threshold and trigger.start > 0) or ((trigger.show == "all" or not trigger.show) and (remains <= (trigger.threshold or 0) and remains > 0 or (GetTime() >= expire and trigger.start > 0))) or (trigger.show == "on" and remains <= (trigger.threshold or 0) and remains > 0) or (trigger.show == "off" and GetTime() >= expire)) then
						--if ((not trigger.threshold and trigger.start > 0) or ((trigger.show == "all" or not trigger.show) and (trigger.threshold or 0) == 0) or ((trigger.show == "all" or not trigger.show) and (trigger.threshold or 0) > 0 and (remains <= (trigger.threshold or 0) and remains > 0 or (GetTime() >= expire and trigger.start > 0))) or (trigger.show == "on" and remains <= (trigger.threshold or 0) and remains > 0) or (trigger.show == "off" and GetTime() >= expire)) then
						if ((not trigger.threshold and trigger.start > 0) or ((trigger.show == "all" or not trigger.show) and (remains <= (trigger.threshold or 0) and remains > 0 or (GetTime() >= expire and type(trigger.treshold) == "number"))) or (trigger.show == "on" and remains <= (trigger.threshold or 0) and remains > 0) or (trigger.show == "off" and GetTime() >= expire)) then
							-- If the trigger has a glow duration time, keep it active after the trigger expiration, otherwise just activate the trigger while it's not expired.
							if ((trigger.show == "all" or trigger.show == "off") and GetTime() >= expire and (trigger.displayTime or 0) > 0) then
								if (GetTime() < (expire + trigger.displayTime)) then
									trigger.isActive = true
								else
									trigger.isActive = false
								end
							else
								trigger.isActive = true
							end
						else
							trigger.isActive = false
						end
					else
						trigger.isActive = false
					end
				else
					trigger.isActive = false
				end
			else
				trigger.isActive = false
			end
		elseif (trigger.type == "charges") then
			-- Check if the trigger is enabled
			if (trigger.isEnabled) then
				-- Check if the trigger's threshold conditions are met
				if (obj.charges <= trigger.threshold and obj.charges > 0) then
					-- Check if the trigger's combat conditions are met
					if (trigger.combat == "all" or (trigger.combat == "on" and Auras:IsPlayerInCombat(true)) or (trigger.combat == "off" and not Auras:IsPlayerInCombat(true))) then
						--SSA.DataFrame.text:SetText("Time: "..GetTime().."\nTrigger: "..trigger.start.."\nDisplay: "..tostring(trigger.displayTime).."\nEnd: "..(trigger.start + trigger.displayTime).."\nTriggered: "..tostring(trigger.isActive))
						if (trigger.displayTime == 0) then
							trigger.isActive = true
						elseif (trigger.displayTime > 0) then
							if (trigger.start == 0) then
								trigger.start = GetTime()
							end
						
							if (GetTime() < (trigger.start + trigger.displayTime) and GetTime() >= trigger.start) then
								trigger.isActive = true
							else
								trigger.isActive = false
							end
						end
					else
						trigger.isActive = false
					end
				else
					trigger.isActive = false
				end
			else
				trigger.isActive = false
			end
		elseif (trigger.type == "interrupt") then
			-- Check if the trigger is enabled
			if (trigger.isEnabled) then
				-- Check if the trigger's combat conditions are met
				if (trigger.combat == "all" or (trigger.combat == "on" and Auras:IsPlayerInCombat(true)) or (trigger.combat == "off" and not Auras:IsPlayerInCombat(true))) then
					-- Check if a target is casting an interruptible cast
					if (obj.isInterruptible) then
						-- If the trigger's start time hasn't been initialize, do so now.
						--[[if (trigger.start == 0) then
							trigger.start = GetTime()
						end]]
						trigger.isActive = true
					else
						--trigger.start = 0
						trigger.isActive = false
					end
				else
					trigger.isActive = false
				end
			end
			--Auras:ToggleOverlayGlow(obj,false)
		end
	end
	
	for i=1,#glow.triggers do
		local trigger = glow.triggers[i]
		
		if (trigger.isActive) then
			if (not obj.pulseTime) then
				--print(obj:GetName())
			end
			if (trigger.pulseRate > 0 and GetTime() >= obj.pulseTime) then
				obj.pulseTime = GetTime() + trigger.pulseRate
				LBG.HideOverlayGlow(obj.glow)
				LBG.ShowOverlayGlow(obj.glow)
			else
				LBG.ShowOverlayGlow(obj.glow)
			end
			
			return
		end
	end
	
	LBG.HideOverlayGlow(obj.glow)
	return
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

function Auras:IsPreviewingAura(obj,grp)
	if (self.db.char.isFirstEverLoad) then
		return false
	end
	
	local auras = self.db.char.auras[SSA.spec]

	-- Because all specs are being funneled into this function, we need to cancel its process if it's trying to check for an aura that does NOT exist within the respective spec
	if (not auras.auras[obj:GetName()]) then
		return false
	end
	
	local group = (grp and grp) or auras.auras[obj:GetName()].group
	
	return self.db.char.settings.move.isMoving or auras.groups[group].isAdjust or (auras.cooldowns.adjust and auras.cooldowns.selected == group)
end

function Auras:IsPreviewingTimerbar(obj)
	if (self.db.char.isFirstEverLoad) then
		return false
	end
	
	local timerbars = self.db.char.timerbars[SSA.spec]
	
	-- Because all specs are being funneled into this function, we need to cancel its process if it's trying to check for a timerbar that does NOT exist within the respective spec
	if (not timerbars.bars[obj:GetName()]) then
		return false
	end

	return self.db.char.settings.move.isMoving or timerbars.groups[timerbars.bars[obj:GetName()].layout.group].isAdjust or timerbars.bars[obj:GetName()].isAdjust
end

function Auras:IsPreviewingStatusbar(obj)
	if (self.db.char.isFirstEverLoad) then
		return false
	end
	
	local statusbars = self.db.char.statusbars[SSA.spec]
	
	if (not statusbars.bars[obj:GetName()]) then
		return false
	end
	
	return self.db.char.settings.move.isMoving or statusbars.bars[obj:GetName()].adjust.isEnabled
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

	-- Create a sub-table for each group of bars
	for i=1,#timerbars.groups do
		barsShowing[i] = {}
	end
	
	-- Collect timer bars that have a start time that's greater than 0
	for k,v in pairs(timerbars.bars) do
		local bar = SSA[k]
		if (bar.start > 0) then
			tinsert(barsShowing[v.layout.group],bar.start)
		elseif (v.isAdjust) then
			tinsert(barsShowing[v.layout.group],k..";"..v.layout.group)
		end
	end
	
	SSA.DataFrame.text:SetText('')
	
	for j=1,#barsShowing do
		table.sort(barsShowing[j])
		for i=1,#barsShowing[j] do
			if (type(barsShowing[j][i]) == "number") then
				for k,v in pairs(timerbars.bars) do
					local bar = SSA[k]
					
					if (bar.start == barsShowing[j][i]) then
						local barGroup = timerbars.groups[v.layout.group]
						
						if (barGroup.layout.growth == "RIGHT" or barGroup.layout.growth == "UP") then
							direction = 1
						elseif (barGroup.layout.growth == "LEFT" or barGroup.layout.growth == "DOWN") then
							direction = -1
						end
			
						local offset = ((((i - 1) * barGroup.layout.spacing) + ((i - 1) * barGroup.layout.height)) + 7.5) * direction
						if (j == 1) then
							SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..k..": "..offset.."\n")
						end

						SSA[k]:ClearAllPoints()
						
						if (barGroup.layout.orientation == "VERTICAL") then
							if (barGroup.barCount <= 1) then
								anchor = "CENTER"
							else
								if (barGroup.layout.growth == "RIGHT") then
									anchor = "LEFT"
								elseif (barGroup.layout.growth == "LEFT") then
									anchor = "RIGHT"
								end
							end
							SSA[k]:SetPoint(anchor,offset,0)
						else
							if (barGroup.barCount <= 1) then
								anchor = "CENTER"
							else
								if (barGroup.layout.growth == "UP") then
									anchor = "BOTTOM"
								elseif (barGroup.layout.growth == "DOWN") then
									anchor = "TOP"
								end
							end
							SSA[k]:SetPoint(anchor,0,offset)
						end
					end
				end
			else
				local anchor = ''
				local barName,barGroupID = strsplit(";",barsShowing[j][i])
				local barGroup = timerbars.groups[tonumber(barGroupID)]
						
				if (barGroup.layout.growth == "RIGHT" or barGroup.layout.growth == "UP") then
					direction = 1
				elseif (barGroup.layout.growth == "LEFT" or barGroup.layout.growth == "DOWN") then
					direction = -1
				end

				local offset = ((((i - 1) * barGroup.layout.spacing) + ((i - 1) * barGroup.layout.height)) + 7.5) * direction
				if (j == 1) then
					SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..barName..": "..offset.."\n")
				end
				SSA[barName]:ClearAllPoints()
				--SSA[barName]:SetPoint(layout.anchor,offset,0)
				if (barGroup.layout.orientation == "VERTICAL") then
					if (barGroup.barCount <= 1) then
						anchor = "CENTER"
					else
						if (barGroup.layout.growth == "RIGHT") then
							anchor = "LEFT"
						elseif (barGroup.layout.growth == "LEFT") then
							anchor = "RIGHT"
						end
					end
					SSA[barName]:SetPoint(anchor,offset,0)
				else
					if (barGroup.barCount <= 1) then
						anchor = "CENTER"
					else
						if (barGroup.layout.growth == "UP") then
							anchor = "BOTTOM"
						elseif (barGroup.layout.growth == "DOWN") then
							anchor = "TOP"
						end
					end
					SSA[barName]:SetPoint(anchor,0,offset)
				end
			end
		end
	end
	
	--twipe(barsShowing)
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
	bar.timetext:SetText(timer)
	
	if (isAdjust) then
		Auras:SortTimerBars(spec)
	else
		if (Auras.db.char.timerbars[spec].groups[group].layout.orientation == "VERTICAL") then
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
	elseif ((timerbar.isAdjust or timerbar.isCustomize or self.db.char.settings.move.isMoving) and timerbar.isInUse) then
		PreviewTimerBar(bar,timerbar.layout.group,timerbar.isAdjust)
	elseif (remains <= 0) then
		bar.start = 0
		bar:Hide()
	end
end

function Auras:RunTimerEvent_Aura(bar,isAnyCaster,...)
	local timerbar = Auras.db.char.timerbars[SSA.spec].bars[bar:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = ...

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