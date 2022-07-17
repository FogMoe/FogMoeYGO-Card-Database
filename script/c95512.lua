--机·械·化
local m=95512
local cm=_G["c"..m]
function c95512.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target1)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(cm.target2)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(cm.target3)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetOperation(cm.activate3)
	c:RegisterEffect(e3)
	--4
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.nametg)
	e4:SetCondition(cm.setcon)
	e4:SetHintTiming(TIMING_END_PHASE)
	e4:SetOperation(cm.nameop)
	c:RegisterEffect(e4)
end

function cm.ctfilter(c)
	return c:IsSetCard(0x9901) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function cm.jixiehua(c)
	return c:IsSetCard(0x9901) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:IsSetCard(0x9901)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct>=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP) and Duel.SelectYesNo(e:GetHandler():GetOwner(),aux.Stringid(m,0)) and Duel.IsExistingMatchingCard(cm.jixiehua,e:GetHandler():GetOwner(),LOCATION_HAND,0,1,nil) then
			Duel.BreakEffect()
			local gc=Duel.SelectMatchingCard(e:GetHandler():GetOwner(),cm.jixiehua,e:GetHandler():GetOwner(),LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(gc,REASON_EFFECT)
		end
	end
end

function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function cm.filter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x9901)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if Duel.IsPlayerCanDraw(tp) and g:GetFirst():IsAbleToRemove() and not g:IsExists(cm.filter2,1,nil) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

function cm.filter3(c)
	return c:IsControlerCanBeChanged() and c:IsSetCard(0x9901)
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return ct>1 and Duel.IsExistingTarget(cm.filter3,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.filter3,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(900)
			tc:RegisterEffect(e1)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(g)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)  
end
function cm.desfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(cm.desfilter,1,nil)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter,nil)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	g:DeleteGroup()
end

function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.namefilter(c,code)
	return c:IsFaceup() and not c:IsCode(code)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9901)
		and Duel.IsExistingMatchingCard(cm.namefilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function cm.nametg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.nameop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g=Duel.SelectMatchingCard(tp,cm.namefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,code)
		local sc=g:GetFirst()
		if sc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(tc:GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_RACE)
			e5:SetValue(RACE_MACHINE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e5)
		end
	end
end