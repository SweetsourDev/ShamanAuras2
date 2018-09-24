local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local TremorTotemBar = SSA.TremorTotemBar

TremorTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,8143)) then
		Auras:RunTimerBarCode(self)
	end
end)

--TremorTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
TremorTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)