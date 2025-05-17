local M = {}

-- Function to open and parse a file
function M.parse_methods_file(file_path)
    -- Check if file exists
    local f = io.open(file_path, "r")
    if not f then
        print("File not found: " .. file_path)
        return nil
    end
    f:close()

    -- Open the file in a buffer
    local bufnr = vim.fn.bufadd(file_path)
    vim.fn.bufload(bufnr)

    -- For this specific file type, we'll use the Groovy parser
    -- You may need to install it first with :TSInstall groovy
    local language = "groovy"

    -- Try to ensure the parser is available
    local parser_ok = pcall(vim.treesitter.language.require_language, language)
    if not parser_ok then
        print("TreeSitter parser for " .. language .. " not available.")
        print("Try running :TSInstall " .. language)
        return nil
    end

    -- Create a parser for the buffer
    local parser = vim.treesitter.get_parser(bufnr, language)
    local tree = parser:parse()[1]
    local root = tree:root()

    -- Extract method definitions
    local methods = M.extract_methods(root, bufnr)

    return methods
end

-- Function to extract method definitions from the parse tree
function M.extract_methods(root, bufnr)
    local methods = {}

    -- Create a query to find method definitions
    -- This query needs to be adjusted based on the actual TreeSitter grammar for Groovy
    local query_str = [[
        (function_call
            name: (identifier) @method_name
            arguments: (arguments
                (named_argument
                    name: (identifier) @param_name
                    value: (_) @param_value
                )*
            )
        )
    ]]

    -- Parse the query
    local query = vim.treesitter.query.parse('groovy', query_str)

    -- Match the query against the syntax tree
    for pattern, match in query:iter_matches(root, bufnr) do
        local method_data = {}

        -- Extract method name
        for id, node in pairs(match) do
            local name = query.captures[id]

            if name == "method_name" then
                method_data.name = vim.treesitter.get_node_text(node, bufnr)
            elseif name == "param_name" or name == "param_value" then
                -- Process parameter information
                -- This needs to be expanded based on the structure of your file
                if not method_data.params then
                    method_data.params = {}
                end

                local param_name = vim.treesitter.get_node_text(node, bufnr)
                -- Add to params...
            end
        end

        if method_data.name and method_data.name == "method" then
            table.insert(methods, method_data)
        end
    end

    -- Since the above query might not work perfectly for your file structure,
    -- let's also try a simpler approach: text-based extraction
    if #methods == 0 then
        return M.extract_methods_fallback(bufnr)
    end

    return methods
end

-- Fallback method extraction using text patterns
function M.extract_methods_fallback(bufnr)
    local methods = {}
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")

    -- Pattern to match method definitions
    for method_text in text:gmatch("method%s*%(.-%)") do
        local method_data = {}

        -- Extract name
        local name = method_text:match("name:%s*'([^']+)'")
        if name then
            method_data.name = name
        end

        -- Extract type
        local type = method_text:match("type:%s*'([^']+)'")
        if type then
            method_data.type = type
        end

        -- Extract params
        local params = method_text:match("params:%s*%[([^%]]+)%]")
        if params then
            method_data.params = {}
            for param_name, param_type in params:gmatch("'([^']+)'%s*:%s*'([^']+)'") do
                method_data.params[param_name] = param_type
            end
        end

        -- Extract namedParams
        local named_params = method_text:match("namedParams:%s*%[([^%]]+)%]")
        if named_params then
            method_data.namedParams = {}
            for param_text in named_params:gmatch("parameter%([^%)]+%)") do
                local param_name = param_text:match("name:%s*'([^']+)'")
                local param_type = param_text:match("type:%s*'([^']+)'")
                if param_name and param_type then
                    method_data.namedParams[param_name] = param_type
                end
            end
        end

        -- Extract doc
        local doc = method_text:match("doc:%s*'([^']+)'")
        if doc then
            method_data.doc = doc
        end

        table.insert(methods, method_data)
    end

    return methods
end

-- Convert methods to Lua tables representation
function M.methods_to_lua(methods)
    local result = "local methods = {\n"

    for i, method in ipairs(methods) do
        result = result .. "  {\n"
        result = result .. "    name = \"" .. (method.name or "") .. "\",\n"
        result = result .. "    type = \"" .. (method.type or "") .. "\",\n"

        -- Add params
        if method.params then
            result = result .. "    params = {\n"
            for param_name, param_type in pairs(method.params) do
                result = result .. "      [\"" .. param_name .. "\"] = \"" .. param_type .. "\",\n"
            end
            result = result .. "    },\n"
        end

        -- Add namedParams
        if method.namedParams then
            result = result .. "    namedParams = {\n"
            for param_name, param_type in pairs(method.namedParams) do
                result = result .. "      [\"" .. param_name .. "\"] = \"" .. param_type .. "\",\n"
            end
            result = result .. "    },\n"
        end

        -- Add doc
        if method.doc then
            result = result .. "    doc = \"" .. method.doc .. "\",\n"
        end

        result = result .. "  },\n"
    end

    result = result .. "}\n\nreturn methods"
    return result
end

-- Main function to parse a file and convert methods to Lua tables
function M.convert_methods_to_lua(file_path, output_path)
    local methods = M.parse_methods_file(file_path)

    if not methods or #methods == 0 then
        print("No methods found in the file.")
        return false
    end

    print("Found " .. #methods .. " methods.")

    local lua_content = M.methods_to_lua(methods)

    -- Write to output file if specified
    if output_path then
        local f = io.open(output_path, "w")
        if not f then
            print("Failed to open output file: " .. output_path)
            return false
        end
        f:write(lua_content)
        f:close()
        print("Methods written to: " .. output_path)
    else
        -- Create a new buffer with the Lua content
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(lua_content, "\n"))
        vim.api.nvim_buf_set_option(buf, "filetype", "lua")
        vim.api.nvim_command("buffer " .. buf)
    end

    return true
end

-- return M

local filepath = os.getenv("HOME").."/.cache/nvim/cmp-jenkinsfile.gdsl"
M.convert_methods_to_lua(filepath, 'out')
