local RESOURCES = {}

function ResolveCredits(resource, colors)
    local text = ""
    local ok = false
    if colors then text = text .. "^2" end
    if resource.name then text = text .. resource.name .. " " ok = true end
    if resource.version then text = text .. "v" .. resource.version .. " " ok = true end
    if colors then text = text .. "^3" end
    if resource.author then
        text = text .. "by "
        if colors then text = text .. "^2" end
        text = text .. resource.author .. ""
        ok = true
    end
    if colors then text = text .. "^3" end
    if resource.contact then text = text .. " (" .. resource.contact .. ")" ok = true end
    if colors then text = text .. "^7" end
    return ok, text
end

function printResourceCredits(resourceName, prefix)
    local resource = {}
    local id = resourceName
    local name, author, contact, version, description, usage, download, details

    if GetNumResourceMetadata(resourceName, "name") > 0 then name = GetResourceMetadata(resourceName, "name", 0) end
    if GetNumResourceMetadata(resourceName, "author") > 0 then author = GetResourceMetadata(resourceName, "author", 0) end
    if GetNumResourceMetadata(resourceName, "contact") > 0 then contact = GetResourceMetadata(resourceName, "contact", 0) end
    if GetNumResourceMetadata(resourceName, "version") > 0 then version = GetResourceMetadata(resourceName, "version", 0) end
    if GetNumResourceMetadata(resourceName, "description") > 0 then description = GetResourceMetadata(resourceName, "description", 0) end
    if GetNumResourceMetadata(resourceName, "usage") > 0 then usage = GetResourceMetadata(resourceName, "usage", 0) end
    if GetNumResourceMetadata(resourceName, "download") > 0 then download = GetResourceMetadata(resourceName, "download", 0) end
    if GetNumResourceMetadata(resourceName, "details") > 0 then details = GetResourceMetadata(resourceName, "details", 0) end

    if name == "" or name == "\n" then name = nil end
    if author == "" or author == "\n" then author = nil end
    if contact == "" or contact == "\n" then contact = nil end
    if version == "" or version == "\n" then version = nil end
    if description == "" or description == "\n" then description = nil end
    if usage == "" or usage == "\n" then usage = nil end
    if download == "" or download == "\n" then download = nil end
    if details == "" or details == "\n" then details = nil end

    local resource = {
        id = id,
        name = name,
        author = author,
        contact = contact,
        version = version,
        description = description,
        usage = usage,
        download = download,
        details = details,
    }

    if name then
        RESOURCES[resourceName] = resource
        local ok, text = ResolveCredits(resource, true)
        if ok then
            print(prefix .. " ^3" .. text)
        end
    end
end

AddEventHandler("onResourceStart", function(resourceName) printResourceCredits(resourceName, "+") end)
AddEventHandler("onResourceStop", function(resourceName) printResourceCredits(resourceName, "-") end)

local CACHE = {
    file = "",
    resources = 0,
    time = 0,
    ok = false,
}

local function sendFile(res, fileName)
	local fileData = LoadResourceFile(GetCurrentResourceName(), 'web/' .. fileName)
	if not fileData then
		res.writeHead(404)
		res.send('Not found.')
		return
	end
	res.send(fileData)
end

local function _p(text)
    return text:gsub("\n","<br/>")
end

SetHttpHandler(function(req, res)
    local path = req.path
    
    -- If cache is not made, expired or resource count has changed
    if not CACHE.ok or CACHE.resources ~= #RESOURCES or CACHE.time < os.clock() then
        local resourceCopy = {}
        for _, resource in next, RESOURCES do
            table.insert(resourceCopy, resource)
        end
        table.sort(resourceCopy, function(a,b) return a.id:upper() < b.id:upper() end)

        local html = ""
        html = html .. "<html><head><title>Server Resource Credits</title></head><body>"
        for _, resource in next, resourceCopy do
            html = html .. "<span id='" .. resource.id .. "'><em><h1 title='" .. resource.id .. "'>" .. (resource.name and resource.name or resource.id) .. "</em>" .. (resource.author and " by " .. resource.author or "") .. "</h1>"
            if resource.name then
                if resource.description then html = html .. ("<h3>%s</h3>"):format(resource.description) end
                if resource.version then html = html .. ("<p><b>Resource Version:</b> %s</p>"):format(resource.version) end
                if resource.contact then html = html .. ("<p><b>Author Contact:</b> <a href='%s'>%s</a></p>"):format((resource.contact:sub(1,4) == "http" and resource.contact or "mailto:" .. resource.contact), resource.contact) end
                if resource.download then html = html .. ("<p><b>Download:</b> <a href='%s'>%s</a></p>"):format(resource.download, resource.download) end
                if resource.usage or resource.details then
                    html = html .. "<details><summary>Details</summary>"
                    if resource.details then html = html .. "<p>" .. resource.details .. "</p>" end
                    if resource.usage then html = html .. "<p>" .. resource.usage .. "</p>" end
                    html = html .. "</details>"
                end
            end
            html = html .. "</span><hr/>"
        end
        html = html .. "</body></html>"

        html = _p(html)

        SaveResourceFile(GetCurrentResourceName(), 'web/cache.html', html, -1)
        CACHE.file = "cache.html"
        CACHE.resources = #RESOURCES
        CACHE.time = os.clock() + 600
        CACHE.ok = true
    end
    
    return sendFile(res, CACHE.file)
end)
