local m=82235
local cm=_G["c"..m]
cm.name="孑影之隐扉"
function cm.initial_effect(c)  
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_END_PHASE)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--salvage  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m+100000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(cm.thcost)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end  
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x3299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,exc,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x3299) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,2,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToHand() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SendtoHand(c,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,c)  
	end  
end  