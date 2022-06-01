--爆炎魔女
local m=66917007
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,66917000)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,66917000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),1,true,true)  
    --actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(1)
    e2:SetCondition(cm.actcon)
    c:RegisterEffect(e2) 
    --attack all
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
function cm.starlight_fusion_check(tp,sg,fc)
    return aux.gffcheck(sg,Card.IsFusionCode,66917000,Card.IsAttribute,ATTRIBUTE_FIRE)
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66917001)
end
function cm.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetValue(HALF_DAMAGE)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end