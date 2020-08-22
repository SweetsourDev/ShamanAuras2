local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local UnleashLifeBar = SSA.UnleashLifeBar

-- Initialize Data Variables
UnleashLifeBar.spellID = 73685
UnleashLifeBar.start = 0
UnleashLifeBar.duration = 10
UnleashLifeBar.elapsed = 0
UnleashLifeBar.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)

	return selected
end

UnleashLifeBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

UnleashLifeBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)