--大引
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local n = Duel.GetFieldGroupCount(tp,1,0) > 1 and 2 or 1
	local g = Duel.GetDecktopGroup(tp,n)
	n = n*100 + cm.gettype(g:GetFirst()) + cm.gettype(g:GetNext())*10
	while n % 10 ~= 0 do
		g = Duel.GetDecktopGroup(tp,(n//100) + 1)
		n = n - n % 100 + n % 10 * 10 + cm.gettype(g:GetFirst()) + 100
		if n % 10 * 10 == n % 100 - n % 10 then break end
	end
	Duel.ConfirmDecktop(tp,n//100)
	Duel.DiscardDeck(tp,n//100,REASON_EFFECT+REASON_REVEAL)
end
function cm.gettype(c)
	return aux.GetValueType(c) ~= "Card" and 0 or (c:IsType(TYPE_SPELL) and 1 or (c:IsType(TYPE_TRAP) and 2 or 3))
end