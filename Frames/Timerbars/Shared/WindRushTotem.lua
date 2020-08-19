local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local WindRushTotemBar = SSA.WindRushTotemBar

-- Initialize Data Variables
WindRushTotemBar.spellID = 192077
WindRushTotemBar.icon = 538576
WindRushTotemBar.start = 0
WindRushTotemBar.duration = 15
WindRushTotemBar.elapsed = 0
WindRushTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(5,3,1)
	
	return selected
end

WindRushTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

WindRushTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)