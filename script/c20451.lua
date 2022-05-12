--安宁茶具
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_ACTIVATE)
	e:SetCategory(e:GetCategory() + CATEGORY_TODECK)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e:SetTarget(cm.tg)
	e:SetOperation(cm.op)
	c:RegisterEffect(e)
	if not cm.global_check then
		cm.global_check = true
		cm[0]=0
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		local c = cm[0]+1
		if chk==0 then 
			if c == 3 then
				return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) 
			elseif c == 4 then
				return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
			elseif c == 5 then
				return Duel.IsPlayerCanDraw(tp,1)
			elseif c == 6 then
				return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			elseif c == 7 then
				return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil)
			elseif c == 8 then
				return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
			else
				return true
			end
		end
		if c == 1 then
			e:SetCategory(e:GetCategory() + e:GetCategory() + CATEGORY_RECOVER)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1000)
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
		elseif c == 3 then
			e:SetCategory(e:GetCategory() + CATEGORY_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
		elseif c == 4 then
			e:SetCategory(e:GetCategory() + CATEGORY_TOGRAVE)
		elseif c == 5 then
			e:SetCategory(e:GetCategory() + CATEGORY_DRAW)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		elseif c == 6 then
			e:SetCategory(e:GetCategory() + CATEGORY_HANDES)
			Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
		elseif c == 7 then
			local g = Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
			e:SetCategory(e:GetCategory() + CATEGORY_TODECK)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_GRAVE)
		elseif c == 8 then
			local g = Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
			e:SetCategory(e:GetCategory() + CATEGORY_REMOVE)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_GRAVE)
		end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
		cm[0] = cm[0]+1
		if cm[0] == 1 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Recover(p,d,REASON_EFFECT)
		elseif cm[0] == 2 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-2500)
		elseif cm[0] == 3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil):GetFirst()
			if tc then Duel.Summon(tp,tc,true,nil) end
		elseif cm[0] == 4 then
			local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_RULE)
		elseif cm[0] == 5 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		elseif cm[0] == 6 then
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif cm[0] == 7 then
			local g7=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
			Duel.SendtoDeck(g7,tp,2,REASON_EFFECT)
		elseif cm[0] == 8 then
			local g8=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
			Duel.Remove(g8,POS_FACEUP,REASON_EFFECT)
		elseif cm[0] == 9 then
			Duel.SetLP(tp,8000)
		else
			Duel.SetLP(1-tp,0)
		end
		Duel.BreakEffect()
		e:GetHandler():CancelToGrave()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end