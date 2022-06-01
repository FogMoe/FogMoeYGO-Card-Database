--暗冥魔女
local m=66917003
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,66917000)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,66917000,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),1,true,true )   
    --lv
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.atktg)
    e2:SetOperation(cm.atkop)
    c:RegisterEffect(e2)  
    --tuner
    local e22=Effect.CreateEffect(c)
    e22:SetDescription(aux.Stringid(m,1))
    e22:SetType(EFFECT_TYPE_QUICK_O)
    e22:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e22:SetCode(EVENT_FREE_CHAIN)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCountLimit(1,m)
    e22:SetTarget(cm.atktg1)
    e22:SetOperation(cm.atkop1)
    c:RegisterEffect(e22) 
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --level
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD)
    e22:SetCode(EFFECT_UPDATE_LEVEL)
    e22:SetRange(LOCATION_MZONE)
    e22:SetTargetRange(0,LOCATION_HAND+LOCATION_MZONE)
    e22:SetCondition(cm.conditions)
    e22:SetValue(-1)
    c:RegisterEffect(e22)
end
function cm.starlight_fusion_check(tp,sg,fc)
    return aux.gffcheck(sg,Card.IsFusionCode,66917000,Card.IsAttribute,ATTRIBUTE_DARK)
end
function cm.filter(c)
    return c:IsFaceup()  and not c:IsLevel(1) and c:IsLevelAbove(1)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(1) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
function cm.filters(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filters(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filters,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.filters,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and cm.filters(tc) then
       if not tc:IsType(TYPE_TUNER) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
       else
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_REMOVE_TYPE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
       end
    end
end
function cm.filterss(c)
    return c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filterss(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filterss,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filterss,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(cm.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function cm.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function cm.cfilters(c)
    return c:IsFaceup() and c:IsCode(66917001)
end
function cm.conditions(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilters,tp,LOCATION_GRAVE,0,1,nil)
end