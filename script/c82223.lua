--跳跃星海
local m=82223
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.check(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)  
end  
function cm.thfilter(c)
	return c:IsSetCard(0x3294) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function cm.tdfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck() and c:IsRace(RACE_MACHINE) and Duel.IsExistingTarget(cm.tdfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function cm.tdfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,cm.tdfilter2,tp,LOCATION_GRAVE,0,1,1,g1)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,3,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,tp,REASON_EFFECT)>0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g:GetCount()>0 then
			local sg=g:Filter(Card.IsRelateToEffect,nil,e)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end