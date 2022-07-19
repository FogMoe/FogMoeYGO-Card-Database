--死亡赌博机
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1fa1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TOSS_COIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
cm.toss_coin=true
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.TossCoin(tp,1)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetCoinResult()
	e:SetLabel(res)
	return true
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	if res==1 then 
		e:GetHandler():AddCounter(0x1fa1,1)
	else
		Duel.Damage(tp,500,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x1fa1)==20 then
		Duel.Win(tp,0xfa1)
	end
end