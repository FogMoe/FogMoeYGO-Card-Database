--雾水魔女
local m=17005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,17000)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,17000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1,true,true)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1) 
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
end
function cm.starlight_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,17000,Card.IsAttribute,ATTRIBUTE_WATER)
end
function cm.cfilter2(c)
	return c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(tp,1000,REASON_EFFECT)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.filter(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.cfilters(c)
	return c:IsFaceup() and c:IsCode(17001)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	Duel.Recover(tp,300,REASON_EFFECT)
end