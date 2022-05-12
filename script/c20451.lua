--安宁茶具
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=cm[0]+1
		if chk==0 then 
			if g==3 then
				Duel.IsExistingMatchingCard(function(c)return c:IsSummonable(true,nil)end,tp,LOCATION_HAND,0,1,nil) 
			elseif g==4 then
				return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
			elseif g==5 then
				return Duel.IsPlayerCanDraw(tp,1)
			elseif g==6 then
				return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			elseif g==7 then
				return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil)
			elseif g==8 then
				return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
			else
				return true
			end
		end
		if g==1 then
			e:SetCategory(CATEGORY_RECOVER)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1000)
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
		elseif g==3 then
			e:SetCategory(CATEGORY_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
		elseif g==4 then
			e:SetCategory(CATEGORY_TOGRAVE)
		elseif g==5 then
			e:SetCategory(CATEGORY_DRAW)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		elseif g==6 then
			e:SetCategory(CATEGORY_HANDES)
			Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
		elseif g==7 then
			local g7=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
			e:SetCategory(CATEGORY_TODECK)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g7,g7:GetCount(),tp,LOCATION_GRAVE)
		elseif g==8 then
			local g8=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
			e:SetCategory(CATEGORY_REMOVE)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g8,g8:GetCount(),1-tp,LOCATION_GRAVE)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		cm[0]=cm[0]+1
		local g=cm[0]
		if g==1 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Recover(p,d,REASON_EFFECT)
		elseif g==2 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-2500)
		elseif g==3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSummonable(true,nil)end,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil,1)
			end
		elseif g==4 then
			local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_RULE)
		elseif g==5 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		elseif g==6 then
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif g==7 then
			local g7=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
			Duel.SendtoDeck(g7,tp,2,REASON_EFFECT)
		elseif g==8 then
			local g8=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
			Duel.Remove(g8,POS_FACEUP,REASON_EFFECT)
		elseif g==9 then
			Duel.SetLP(tp,8000)
		else
			Duel.SetLP(1-tp,0)
		end
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
	end
end