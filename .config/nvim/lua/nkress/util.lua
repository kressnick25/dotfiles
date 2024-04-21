function string:contains(sub)
    return self:find(sub, 1, true) ~= nil
end

function string:startswith(start)
    return self:sub(1, #start) == start
end

function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

function Atwork()
    return vim.fn.hostname().startswith("WVA")
end

function IsUnix()
    return vim.has.has('unix')
end

function IsWin()
    return vim.fn.has('win32') or vim.fn.has('win64')

end
