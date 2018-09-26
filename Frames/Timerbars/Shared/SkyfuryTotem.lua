local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SkyfuryTotemBar = SSA.SkyfuryTotemBar

-- Initialize Data Variables
SkyfuryTotemBar.spellID = 204330
SkyfuryTotemBar.icon = 135829
SkyfuryTotemBar.start = 0
SkyfuryTotemBar.duration = 15
SkyfuryTotemBar.condition = function() 
	local spellID
	local spec = GetSpecialization()
	
	if (spec == 1) then
		spellID = 3488
	elseif (spec == 2) then
		spellID = 3487
	elseif (spec == 3) then
		spellID = 707
	end
	
	return select(10,GetPvpTalentInfoByID(spellID)) and Auras:IsPvPZone()
end

SkyfuryTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3488") or Auras:CharacterCheck(self,2,"3487") or Auras:CharacterCheck(self,3,"707")) then
		Auras:RunTimerBarCode(self)
	end
end)

SkyfuryTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)