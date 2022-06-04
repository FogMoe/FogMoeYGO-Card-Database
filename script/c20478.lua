--虚数转生
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.exccon)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tgf1(c,n,t)
	if not c:IsCode(m+n) then return end
	if t==0 then return c:IsAbleToRemoveAsCost() end
	if t==1 then return c:IsAbleToHand() end
	return false
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_GRAVE,0,1,nil,1,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_GRAVE,0,1,1,nil,1,0)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,0,1) and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,1,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_DECK,0,nil,0,1)
	g:Merge(Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_DECK,0,nil,1,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if g and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
