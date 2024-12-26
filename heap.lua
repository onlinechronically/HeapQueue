local Heap = {}

local function getParentIndex(index)
    if index == 1 then return nil end
    return math.floor(index / 2)
end

local function getChildIndex(index, isLeft)
    local childIndex = isLeft and (2 * index) or (2 * index + 1)
    if childIndex > #Heap then return nil end
    return childIndex
end

local function getMinChild(index)
    local left = getChildIndex(index, true)
    local right = getChildIndex(index, false)
    if not left or not right then return nil end
    if Heap[left].priority > Heap[right].priority then
        return left
    elseif Heap[right].priority > Heap[left].priority then
        return right
    elseif Heap[left].priority == Heap[right].priority then
        if Heap[right].time < Heap[left].time then
            return right
        else
            return left
        end
    end
end

local function swap(i, j)
    local temp = Heap[i]
    Heap[i] = Heap[j]
    Heap[j] = temp
end

local function moveDown(index)
    local minChild = getMinChild(index)
    if minChild then
        if Heap[index].priority < Heap[minChild].priority then
            swap(minChild, index)
        elseif Heap[index].priority == Heap[minChild].priority and Heap[index].time > Heap[minChild].time then
            swap(minChild, index)
        end
    end
end

local function moveUp(index)
    local parent = getParentIndex(index)
    if parent then
        if Heap[index].priority > Heap[parent].priority then
            swap(index, parent)
        elseif Heap[index].priority == Heap[parent].priority and Heap[index].time < Heap[parent].time then
            swap(index, parent)
        end
    end
end

function HeapInsert(value)
    table.insert(Heap, value)
    moveUp(#Heap)
end

function HeapExtract()
    swap(1, #Heap)
    local extractedEntry = table.remove(Heap, #Heap)
    moveDown(1)
    return extractedEntry
end

Citizen.CreateThread(function()
    local total = 1
    while true do
        Citizen.Wait(1000)
        local counter = 0
        for position, entry in ipairs(Heap) do
            if entry.network_violations < 60 and GetPlayerLastMsg(entry.id) > 30000 then
                entry.network_violations = entry.network_violations + 1
            end
            if entry.network_violations < 60 then
                entry.deferrals.update("Queue Position: " ..
                    counter .. "/" .. total .. "\nTime Elapsed: " .. os.time() - entry.time .. " seconds")
                counter = counter + 1
            end
        end
        total = counter
    end
end)
