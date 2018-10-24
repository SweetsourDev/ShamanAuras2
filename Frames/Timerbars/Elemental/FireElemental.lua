local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local select = select

-- Cache Global WoW API Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

-- Cache Global Addon Variables
local FireElementalBar = SSA.FireElementalBar
local EmberElementalBar = SSA.EmberElementalBar
local PrimalFireElementalBar = SSA.PrimalFireElementalBar

-- Initialize Data Variables
FireElementalBar.spellID = 188592
FireElementalBar.icon = 135790
FireElementalBar.start = 0
FireElementalBar.duration = 30
FireElementalBar.GUID = ''
FireElementalBar.condition = function()
	return not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067)
end

FireElementalBar:SetScript('OnUpdate',function(self)
	--if (Auras:CharacterCheck(self,1,198067) and not select(4,GetTalentInfo(4,2,1)) and not select(4,GetTalentInfo(6,2,1))) then
	if ((Auras:CharacterCheck(self,1,198067) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

FireElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)

-- Initialize Data Variables
EmberElementalBar.spellID = 275385
EmberElementalBar.icon = 135790
EmberElementalBar.start = 0
EmberElementalBar.duration = 30
EmberElementalBar.GUID = ''
EmberElementalBar.condition = function() return not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067) end

EmberElementalBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

EmberElementalBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Elemental(self,nil,CombatLogGetCurrentEventInfo())
end)

-- Initialize Data Variables
PrimalFireElementalBar.spellID = 118291
PrimalFireElementalBar.start = 0
PrimalFireElementalBar.duration = 30
PrimalFireElementalBar.GUID = ''
PrimalFireElementalBar.isPrimal = true
PrimalFireElementalBar.condition = function() return select(4,GetTalentInfo(6,2,1)) and not select(4,GetTalentInfo(4,2,1)) end

PrimalFireElementalBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1,6,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

PrimalFireElementalBar:SetScript("OnEvent",function(self,event)
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
--[[
	NO TALENT
	---------
	Event: SPELL_SUMMON
	GUID: Player (Arg 4), Pet (Arg 8)
	
	Event: UNIT_DIED
	GUID: Pet (Arg 8)

	Event: SPELL_CAST_SUCCESS
	GUID: Player (Arg 4)
	Spell ID: 198067
	
	Event: SPELL_AURA_APPLIED 
	GUID: Player (Arg 4)
	Spell ID: 188592
	
	Event: SPELL_AURA_REMOVED
	GUID: Player (Arg 4)
	Spell ID: 188592
	
	
	TALENTED
	--------
	Event: PET_DISMISS_START
]]