--极天零序龙
local cm,m,o=GetID()
fu_zeroth = fu_zeroth or {}
function fu_zeroth.same(c,code,zero_eff)
	aux.AddCodeList(c,20751,20758)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(fu_zeroth.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(fu_zeroth.op2(code,zero_eff))
	c:RegisterEffect(e2)
	local e3=zero_eff(c)
	c:RegisterEffect(e3)
	return e1,e2,e3
end
--e1
function fu_zeroth.val1(e,se,sp,st)
	return se:GetHandler():IsCode(20751) or se:GetHandler():IsCode(20758)
end
--e2
function fu_zeroth.op2(code,zero_eff)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=zero_eff(c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(fu_zeroth.op2tg2)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,code,0,0,1)
	end
end
function fu_zeroth.op2tg2(e,c)
	return c:IsCode(20758)
end
if not cm then return end
function cm.initial_effect(c)
	local e1={fu_zeroth.same(c,m,cm.Zeroth_Effect)}
end
--Zeroth_Effect
function cm.Zeroth_Effect(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(m,0))
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetTarget(cm.Zeroth_Effect_tg)
	e:SetOperation(cm.Zeroth_Effect_op)
	return e
end
function cm.Zeroth_Effect_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end
function cm.Zeroth_Effect_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(1)
	e1:SetCondition(cm.Zeroth_Effect_opcon)
	c:RegisterEffect(e1)
end
function cm.Zeroth_Effect_opcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end