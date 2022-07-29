--秘银龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m-1)
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cos)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,m-1)
end
function cm.cos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct={}
	for i=3,1,-1 do
		if Duel.IsPlayerCanDiscardDeckAsCost(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then
		Duel.DiscardDeck(tp,ct[1],REASON_COST)
		e:SetLabel(Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER))
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER))
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	local ct=e:GetLabel()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*(-300))
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end