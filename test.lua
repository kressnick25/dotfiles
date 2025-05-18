-- local path = "./test.groovy"
-- local path = os.getenv("HOME") .. "/.cache/nvim/cmp-jenkinsfile.gdsl"
local path = "./gdsl.groovy"
local buf = vim.fn.bufadd(path)
vim.fn.bufload(buf)

local parser = vim.treesitter.get_parser(buf, 'groovy')
print(parser)

--- @param node TSNode?
--- @return string
local function node_text(node)
    if node ~= nil then
        return vim.treesitter.get_node_text(node, buf)
    else
        return "nil"
    end
end

local function traverse_node(node, indent)
    indent = indent or 0
    local indent_str = string.rep("  ", indent)

    -- Print node information
    print(indent_str .. "Node: " .. node:type())

    -- Traverse child nodes
    for child, _ in node:iter_children() do
        traverse_node(child, indent + 1)
    end
end

-- bloody lua indexes start at 1, but treesitter indexes start at 0

-- @param s string
-- @return string
local function strip_surround(s)
    local res
    res = s:sub(2, -1)
    res = res:sub(1, res:len() - 1)
    return res
end

-- @param s string
-- @return boolean
local function is_in_quotes(s)
    return s:sub(1, 1) == "'" or s:sub(1, 1) == "\""
end

--- @param node TSNode
--- @return table
local function parse_params(node)
    local params = {}
    if node:type() ~= "map" then
        error("parse_params: unexpected node type: " .. node:type())
    end

    for _, key_value_pair_node in ipairs(node:named_children()) do
        local key = node_text(key_value_pair_node:named_child(0))
        local val = node_text(key_value_pair_node:named_child(1))
        -- strip surrounding quotes
        if is_in_quotes(key) then
            key = strip_surround(key)
        end
        if is_in_quotes(val) then
            val = strip_surround(val)
        end
        params[key] = val
    end

    return params
end

--- @param node TSNode
--- @return table
local function parse_named_parameter(node)
    return {}
end


--- @param node TSNode
--- @return table
local function parse_named_params(node)
    return {}
end

--- @param map table
local function format_map(map)
    local result = "{\n"

    for k, v in pairs(map) do
        result = result .. "\t'" .. k .. "' : '" .. v .. "',\n"
    end

    result = result .. "}"
    return result
end

if parser ~= nil then
    local tree = parser:parse(true)[1]
    local root = tree:root()

    print("Root node type: " .. root:type())
    local has_children = false
    local count = 0

    for _ in root:iter_children() do
        has_children = true
        count = count + 1
    end


    -- print("Root has children: " .. tostring(has_children) .. " (count: " .. count .. ")")
    -- traverse_node(root)

    -- get all function calls with function name == "method"
    -- TODO refine, this is picking up 'method' as well as 'method()' (want 2nd not first)
    local method_query = vim.treesitter.query.parse('groovy', [[
        ;query
        (function_call function: ((identifier) @method_name (#eq? @method_name "method"))) @m
    ]])
    for id, node, metdata in method_query:iter_captures(root, buf) do
        -- print(node:type())
        if node:type() == "function_call" then
            -- print(vim.treesitter.get_node_text(node, buf))
            local argument_list = node:child(1)

            local def = {}
            if argument_list ~= nil then
                -- print(argument_list:type())
                -- print(vim.treesitter.get_node_text(argument_list, buf))

                for arg in argument_list:iter_children() do
                    -- print(arg:type())
                    -- print(vim.treesitter.get_node_text(arg, buf))
                    local key_node = arg:child(0)
                    local val_node = arg:child(2)
                    if key_node ~= nil then
                        -- @type string
                        local key = vim.treesitter.get_node_text(key_node, buf)
                        if val_node ~= nil then
                            -- type string|table
                            local val = nil
                            if key == "params" then
                                val = parse_params(val_node)
                            elseif key == "namedParams" then
                                val = parse_named_params(val_node)
                            else
                                val = vim.treesitter.get_node_text(val_node, buf)
                                def[key] = val
                            end
                            def[key] = val
                        end
                    end
                end
            end
            print("!!table def is")
            for key, val in pairs(def) do
                if type(val) == "table" then
                    print("key: " .. key .. " val: " .. format_map(val))
                else
                    print("key: " .. key .. " val: " .. val)
                end
            end
            print("!! end table")
        end


        break
    end
end


-- (function_call function: ((identifier) @method_name (#eq? @method_name "method"))) @m
-- (map_item key: ((identifier) @key_val (#eq? @key_val "name"))) @n
-- (map_item key: ((identifier) @key_val (#eq? @key_val "type"))) @t
-- (map_item key: ((identifier) @key_val (#eq? @key_val "params"))) @p
-- (map_item key: ((identifier) @key_val (#eq? @key_val "namedParams"))) @nP
