-- local path = "./test.groovy"
-- local path = os.getenv("HOME") .. "/.cache/nvim/cmp-jenkinsfile.gdsl"
local path = "./gdsl.groovy"
local buf = vim.fn.bufadd(path)
vim.fn.bufload(buf)

local parser = vim.treesitter.get_parser(buf, 'groovy')
print(parser)

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


    print("Root has children: " .. tostring(has_children) .. " (count: " .. count .. ")")
    -- traverse_node(root)

    -- get all function calls with function name == "method"
    -- TODO refine, this is picking up 'method' as well as 'method()' (want 2nd not first)
    local method_query = vim.treesitter.query.parse('groovy', [[
        ;query
        (function_call function: ((identifier) @method_name (#eq? @method_name "method"))) @m
    ]])
    for id, node, metdata in method_query:iter_captures(root, buf) do
        -- print(node:type())
        print(vim.treesitter.get_node_text(node, buf))
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
                    local key = vim.treesitter.get_node_text(key_node, buf)
                    -- print("key is " .. key)
                    if val_node ~= nil then
                        local val = vim.treesitter.get_node_text(val_node, buf)
                        -- print("val is " .. val)
                        if key == "params" then
                            def[key] = val
                            -- TODO parse key-val param map
                        elseif key == "namedParams" then
                            def[key] = val
                            -- TODO parse list of name/type params
                        else
                            def[key] = val
                        end
                    end
                end
            end
        end
        print("!!table def is")
        for key, val in pairs(def) do
            print("key: " .. key .. " val: " .. val)
        end


        -- break
    end
end


-- (function_call function: ((identifier) @method_name (#eq? @method_name "method"))) @m
-- (map_item key: ((identifier) @key_val (#eq? @key_val "name"))) @n
-- (map_item key: ((identifier) @key_val (#eq? @key_val "type"))) @t
-- (map_item key: ((identifier) @key_val (#eq? @key_val "params"))) @p
-- (map_item key: ((identifier) @key_val (#eq? @key_val "namedParams"))) @nP
