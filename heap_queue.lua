local ActionQueue = {
    first = nil,
    last = nil,
    size = 0
}

function Enqueue(type, entry)
    if ActionQueue.size == 0 then
        ActionQueue.first = {
            value = entry,
            type = type,
            next = nil
        }
        ActionQueue.last = ActionQueue.first
    else
        ActionQueue.last.next = {
            value = entry,
            type = type,
            next = nil
        }
        ActionQueue.last = ActionQueue.last.next
    end
    ActionQueue.size = ActionQueue.size + 1
end

local function dequeue()
    if ActionQueue.size == 0 then
        return nil
    else
        local first = ActionQueue.first
        if not first then return nil end
        if not ActionQueue.first.next then ActionQueue.last = nil end
        ActionQueue.first = ActionQueue.first.next
        ActionQueue.size = ActionQueue.size - 1
        return { value = first.value, type = first.type }
    end
end
