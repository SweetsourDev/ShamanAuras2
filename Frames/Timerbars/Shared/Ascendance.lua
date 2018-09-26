local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AscendanceBar = SSA.AscendanceBar

local spec = GetSpecialization()

--Initialize Data Variables
AscendanceBar.spellID = (spec == 1 and 114050) or (spec == 2 and 114051) or (spec == 3 and 114052)
AscendanceBar.start = 0
AscendanceBar.duration = 15
AscendanceBar.condition = function()
	return select(4,GetTalentInfo(7,3,1))
end

AscendanceBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,7,3)) then
		Auras:RunTimerBarCode(self)
	end
end)

AscendanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)