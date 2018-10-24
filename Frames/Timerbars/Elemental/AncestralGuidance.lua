local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local AncestralGuidanceBar = SSA.AncestralGuidanceBar

AncestralGuidanceBar.spellID = 108281
AncestralGuidanceBar.start = 0
AncestralGuidanceBar.duration = 10
AncestralGuidanceBar.condition = function()
	local _,_,_,selected = GetTalentInfo(5,2,1)
	
	return selected
end

AncestralGuidanceBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,1) and self.condition) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

AncestralGuidanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)