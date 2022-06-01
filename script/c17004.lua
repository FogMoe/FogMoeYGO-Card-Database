--天风魔女
local m=66917004
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,66917000)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,66917000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,true,true) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetHintTiming(0,0x1e0)
	e6:SetTarget(cm.rmtg)
	e6:SetOperation(cm.rmop)
	c:RegisterEffect(e6)
	--handlock 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.conditions)
	e2:SetTargetRange(0,1)
	e2:SetValue(3)
	c:RegisterEffect(e2) 
end
function cm.starlight_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,66917000,Card.IsAttribute,ATTRIBUTE_WIND)
end
function cm.tfilter2(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(cm.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.spfilter(c,e,tp,lv,att,rac)
	return c:GetLevel()~=lv and c:IsAbleToHand() and c:GetAttribute()~=att and c:GetRace()~=rac and c:IsType(TYPE_MONSTER)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=g:GetCount()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local lv=tg:GetFirst():GetLevel()
	local att=tg:GetFirst():GetAttribute()
	local rac=tg:GetFirst():GetRace()
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
		local opc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local gnc=ct-opc
		if gnc==0 and tg:GetFirst():GetControler()==1-tp then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
		if gnc==0 and tg:GetFirst():GetControler()==tp and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv,att,rac) then
			local ag=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv,att,rac)
			if ag:GetCount()>0 then
			  Duel.SendtoHand(ag,tp,REASON_EFFECT)
			end
		end
	end
end
function cm.cfilters(c)
	return c:IsFaceup() and c:IsCode(66917001)
end
function cm.conditions(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end