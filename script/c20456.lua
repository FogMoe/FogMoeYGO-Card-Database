--诡秘黑核
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.IsPlayerCanDraw(tp,2) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		if Duel.GetLP(1-tp)>1000 then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.PayLPCost(tp,2000)~=0 and Duel.IsChainDisablable(0) and Duel.CheckLPCost(1-tp,1000)
			and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			Duel.PayLPCost(1-tp,1000)
			Duel.NegateEffect(0)
			return
		end
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
end
