local function table_length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

local function test_baseline(num_elements)
    local start = os.clock()
    for _ = 1, 10000 do
        local subs_array = {}
        for i = 1, num_elements do
            local length = table_length(subs_array)
            subs_array[length] = true
        end
        local check = table_length(subs_array) > 0
    end
    return os.clock() - start
end

local function test_optimized(num_elements)
    local start = os.clock()
    for _ = 1, 10000 do
        local subs_array = {}
        local subs_count = 0
        for i = 1, num_elements do
            subs_array[subs_count] = true
            subs_count = subs_count + 1
        end
        local check = subs_count > 0
    end
    return os.clock() - start
end

local num = 50
local baseline_time = test_baseline(num)
local optimized_time = test_optimized(num)

print(string.format("Baseline time: %.4f seconds", baseline_time))
print(string.format("Optimized time: %.4f seconds", optimized_time))
print(string.format("Improvement: %.2fx faster", baseline_time / optimized_time))
