-- Single place every other client file reads from.

State = {
    ready      = false,
    open       = false,       -- studio panels open
    canEdit    = false,
    locale     = Config.DefaultLocale,

    cards      = {},          -- id -> card record (server truth)
    order      = {},          -- ids, newest first
    draft      = nil,         -- card being edited in the studio (live, unsaved)
    selectedId = nil,

    visible    = true,        -- master "cards visible" toggle
    metrics    = {},          -- id -> { w, h } measured by the NUI
    active     = {},          -- id -> { dist, alpha, x, y, scale, yaw, on }
    hovered    = nil,
    gizmoMode  = 'move',      -- move | rotate | off
    freecam    = false,
    aiBusy     = false,
}

-- Metres per 300 CSS pixels. Keeps a 300px tall card roughly 1 m tall.
State.PIXELS_PER_METRE = 300.0

function State.SetCards(list)
    State.cards, State.order = {}, {}
    for _, card in ipairs(list or {}) do
        State.cards[card.id] = card
        State.order[#State.order + 1] = card.id
    end
end

function State.Upsert(card)
    if not card or not card.id then return end
    if not State.cards[card.id] then
        table.insert(State.order, 1, card.id)
    end
    State.cards[card.id] = card
end

function State.Remove(id)
    State.cards[id] = nil
    State.active[id] = nil
    State.metrics[id] = nil
    for i = #State.order, 1, -1 do
        if State.order[i] == id then table.remove(State.order, i) end
    end
    if State.selectedId == id then
        State.selectedId, State.draft = nil, nil
    end
end

--- The record that should actually be drawn: the live draft wins over the saved copy.
function State.Live(id)
    if State.draft and State.draft.id == id then return State.draft end
    return State.cards[id]
end

function State.List()
    local out = {}
    for _, id in ipairs(State.order) do
        local card = State.Live(id)
        if card then out[#out + 1] = card end
    end
    if State.draft and not State.cards[State.draft.id] then
        table.insert(out, 1, State.draft)
    end
    return out
end

function State.Size(id)
    local m = State.metrics[id]
    if not m then return 420.0, 180.0 end
    return m.w, m.h
end
