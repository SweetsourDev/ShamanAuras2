-- these are the esES localizations
-- we will use the Wowace localization system
-- since this isn't the default, check and exit if not esES

local L = LibStub("AceLocale-3.0"):NewLocale("ShamanAurasDev", "esES")

if not L then
	return
end
