local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTime = GetTime

-- Cache Global Addon Variables
local AncestralGuidanceBar = SSA.AncestralGuidanceBar

AncestralGuidanceBar.spellID = 108281
AncestralGuidanceBar.start = 0
AncestralGuidanceBar.duration = 10
AncestralGuidanceBar.elapsed = 0
AncestralGuidanceBar.condition = function()
	local _,_,_,selected = GetTalentInfo(5,2,1)
	
	return selected
end

AncestralGuidanceBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1) and self.condition) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

AncestralGuidanceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,1) and self.condition) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)