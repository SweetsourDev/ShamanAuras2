local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CloudburstTotemBar = SSA.CloudburstTotemBar

-- Initialize Data Variables
CloudburstTotemBar.spellID = 157153
CloudburstTotemBar.icon = 971076
CloudburstTotemBar.start = 0
CloudburstTotemBar.duration = 15
CloudburstTotemBar.elapsed = 0
CloudburstTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(6,3,1)
	
	return selected
end

CloudburstTotemBar:SetScript('OnUpdate',function(self,elapsed)
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

CloudburstTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)