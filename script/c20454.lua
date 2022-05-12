--诀别
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:Filter(cm.cfilter,nil,tp):GetFirst()
		if not tc then return false end
		return true
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tc=eg:Filter(function(c)
			return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and (c:IsReason(REASON_BATTLE) or rp==1-tp) and c:IsAbleToRemoveAsCost()
		end,nil):GetFirst()
		if chk==0 then return tc end
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,atk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		local c=Duel.GetAttacker()
		local atk=c:GetAttack()
		if atk<0 then atk=0 end
		e:SetLabel(atk)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(atk)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Recover(p,d,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(tp)
end