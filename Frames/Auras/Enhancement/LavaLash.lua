local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local LavaLash = SSA.LavaLash

-- Intialize Data Variables
LavaLash.spellID = 60103
LavaLash.pulseTime = 0
LavaLash.elapsed = 0
LavaLash.condition = function()
	return IsSpellKnown(60103)
end

LavaLash:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local db = Auras.db.char
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				local buff,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player',215785)
				
				--local power = UnitPower('player',Enum.PowerType.Maelstrom)
				
				Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,215785,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)
				
				if (Auras:IsPlayerInCombat()) then
					self:SetAlpha(1)
					--[[local powerCost = GetSpellPowerCost(self.spellID)
					
					if (power >= powerCost[1].cost or buff) then
						self:SetAlpha(1)
					else
						self:SetAlpha(0.5)
					end]]
				else
					Auras:NoCombatDisplay(self,groupID)
				end
			else
				Auras:ToggleAuraVisibility(self,false,'showhide')
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)
