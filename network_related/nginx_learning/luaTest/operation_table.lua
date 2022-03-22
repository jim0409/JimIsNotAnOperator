-- Create an array
local arr = {"a", "b", "c", "d", "e"}


-- Retrieve the 3ed element
print(arr[1]) -- 打印 a ... 因為 lua 的table是從第 1 個數開始算的
print("-------")


local arr1 = {}

arr1[1] = "a"
arr1[2] = "b"
-- arr[3] and arr[4] are nil
arr1[5] = "e"
arr1[6] = "f"

-- 在lua中陣列的空洞會導致打印無法連續
function printOutLuaArray(arr1)
    for i, j in ipairs(arr1) do
        print(j)
    end
end

printOutLuaArray(arr1)
print("-------")

arr1[3]=1
arr1[4]=2

printOutLuaArray(arr1)


