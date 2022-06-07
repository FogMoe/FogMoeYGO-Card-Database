--凶堕魔凰
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20511)
	c:EnableReviveLimit()
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_EXTRA_ATTACK)
	e:SetValue(1)
	c:RegisterEffect(e)
end
