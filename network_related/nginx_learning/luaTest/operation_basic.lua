function fun(n)
    if n<2 then return 1 end
    return fun(n-2) + fun(n-1)
end

print(fun(8))