--守城-防御堡垒瞭望哨站塔楼
local m=95715
local cm=_G["c"..m]
function c95715.initial_effect(c)
	--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e9)
		--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
end
function cm.cfilter2(c)
	return c:IsDefensePos() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9905) and c:IsFaceup()
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local rec=GetMatchingGroupCount(cm.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*150
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9905)
end
function cm.costchk(e,te_or_c,tp)
	local numbs=GetMatchingGroupCount(cm.cfilter1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	return Duel.CheckLPCost(tp,150*numbs)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local numbs=GetMatchingGroupCount(cm.cfilter1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	Duel.PayLPCost(tp,150*numbs)
end