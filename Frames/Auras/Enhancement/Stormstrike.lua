local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsPlayerKnown = IsPlayerKnown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Stormstrike = SSA.Stormstrike

-- Initialize Data Variables
Stormstrike.spellID = 17364
Stormstrike.pulseTime = 0
Stormstrike.elapsed = 0
Stormstrike.condition = function()
	return IsPlayerSpell(17364)
end

Stormstrike:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player',201846) -- Stormbringer
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))

				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,201846,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)
				
				if (Auras:IsPlayerInCombat()) then
					self:SetAlpha(1)

					if (not buff) then
						self.CD:SetAlpha(1)
						self.CD.text:SetAlpha(1)
					elseif (buff and Auras:IsPlayerInCombat(true)) then
						self.CD:SetAlpha(0)
						self:SetAlpha(1)
						self.CD:SetCooldown(0,0)
						self.CD.text:SetText('')
					end
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