local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CounterstrikeTotemBar = SSA.CounterstrikeTotemBar

-- Initialize Data Variables
CounterstrikeTotemBar.spellID = 204331
CounterstrikeTotemBar.icon = 511726
CounterstrikeTotemBar.start = 0
CounterstrikeTotemBar.duration = 15
CounterstrikeTotemBar.condition = function() 
	local spellID
	local spec = GetSpecialization()
	
	if (spec == 1) then
		spellID = 3490
	elseif (spec == 2) then
		spellID = 3489
	elseif (spec == 3) then
		spellID = 708
	end
	
	return select(10,GetPvpTalentInfoByID(spellID)) and Auras:IsPvPZone()
end

CounterstrikeTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3490") or Auras:CharacterCheck(self,2,"3489") or Auras:CharacterCheck(self,3,"708")) then
		Auras:RunTimerBarCode(self)
	end
end)

CounterstrikeTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)