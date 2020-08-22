local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local EarthbindTotem = SSA.Earthbind_Totem
EarthbindTotem.isClicked = false

EarthbindTotem:SetPoint("CENTER",SSA.AuraBase,"CENTER",0,0)

local function TotemDestroyHandler()
	--print("Destroyed Totem")
end

EarthbindTotem:SetScript("OnMouseDown",function(self,button)
	--print("BUTTON: "..tostring(button))
	--self.isClicked = true
	hooksecurefunc("DestroyTotem",TotemDestroyHandler)
end)

EarthbindTotem:SetScript("OnUpdate",function(self,elapsed)
	if (self.isClicked) then
		DestroyTotem(1)
		self.isClicked = false
	end
end)