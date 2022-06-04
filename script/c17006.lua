--大地魔女
local m=17006
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,17000)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,17000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,true,true) 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.tgcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(cm.tgcon)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)  
	--defense attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DEFENSE_ATTACK)
	e11:SetValue(1)
	e11:SetCondition(cm.conditions)
	c:RegisterEffect(e11)
end
function cm.starlight_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,17000,Card.IsAttribute,ATTRIBUTE_EARTH)
end
function cm.tgcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end
function cm.cfilters(c)
	return c:IsFaceup() and c:IsCode(17001)
end
function cm.conditions(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end