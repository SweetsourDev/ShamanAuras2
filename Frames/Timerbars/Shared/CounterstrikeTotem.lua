local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CounterstrikeTotemBar = SSA.CounterstrikeTotemBar

CounterstrikeTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3490") or Auras:CharacterCheck(self,2,"3489") or Auras:CharacterCheck(self,3,"708")) then
		Auras:RunTimerBarCode(self)
	end
end)

--CounterstrikeTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
CounterstrikeTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)