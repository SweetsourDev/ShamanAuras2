local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetSpecialization = GetSpecialization

-- Cache Global Addon Variables
local GroundingTotemBar = SSA.GroundingTotemBar

-- Initialize Data Variables
GroundingTotemBar.spellID = 204336
GroundingTotemBar.icon = 136039
GroundingTotemBar.start = 0
GroundingTotemBar.duration = 3
GroundingTotemBar.condition = function() 
	local spellID
	local spec = GetSpecialization()
	
	if (spec == 1) then
		spellID = 3620
	elseif (spec == 2) then
		spellID = 3622
	elseif (spec == 3) then
		spellID = 715
	end
	
	return select(10,GetPvpTalentInfoByID(spellID)) and Auras:IsPvPZone()
end

GroundingTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3620") or Auras:CharacterCheck(self,2,"3622") or Auras:CharacterCheck(self,3,"715")) then
		Auras:RunTimerBarCode(self)
	end
end)

GroundingTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)