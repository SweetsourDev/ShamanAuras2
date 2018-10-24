local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local select = select

-- Cache Global WoW API Functions
local GetTalentInfo = GetTalentInfo
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

-- Cache Global Addon Variables
local PrimalStormElementalBar = SSA.PrimalStormElementalBar
local StormElementalBar = SSA.StormElementalBar

-- Initialize Data Variables
StormElementalBar.spellID = 157299
StormElementalBar.icon = 2065626
StormElementalBar.start = 0
StormElementalBar.duration = 30
StormElementalBar.GUID = ''
StormElementalBar.condition = function() 
	local _,_,_,selected1 = GetTalentInfo(4,2,1)
	local _,_,_,selected2 = GetTalentInfo(6,2,1)

	return selected1 and not selected2
end

StormElementalBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

--StormElementalBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
StormElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)

-- Initialize Data Variables
PrimalStormElementalBar.spellID = 157319
PrimalStormElementalBar.start = 0
PrimalStormElementalBar.duration = 30
PrimalStormElementalBar.GUID = ''
PrimalStormElementalBar.isPrimal = true
PrimalStormElementalBar.condition = function()
	local _,_,_,selected1 = GetTalentInfo(6,2,1)
	local _,_,_,selected2 = GetTalentInfo(4,2,1)
	
	return selected1 and selected2
end

PrimalStormElementalBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

--PrimalStormElementalBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
PrimalStormElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	--[[local spec = 1
	local timerbar = Auras.db.char.timerbars[spec][self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,_,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (srcGUID == UnitGUID("player") and subevent == "SPELL_SUMMON") then
		-- If the player casts Primal Earth Elemental while the Primal Fire Elemental is already active,
		-- hide the timer bar for Primal Fire Elemental
		if (spellID == 118323 and timerbar.startTime > 0) then
			timerbar.startTime = 0
		elseif (spellID == timerbar.spellID) then
			timerbar.startTime = GetTime()
			timerbar.event.elementalGUID = destGUID
			self:Show()
		end
	elseif (subevent == "UNIT_DIED" and destGUID == timerbar.event.elementalGUID) then
		timerbar.startTime = 0
	end]]
	Auras:RunTimerEvent_Elemental(self,118323,CombatLogGetCurrentEventInfo())
end)