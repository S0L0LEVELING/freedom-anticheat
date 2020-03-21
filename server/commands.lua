FAC.Commands = {}

FAC.IsConsole = function(playerId)
    return (playerId == nil or playerId <= 0 or tostring(playerId) == '0')
end

RegisterCommand('anticheat', function(source, args, raw)
    if (not FAC.PlayerAllowed(source)) then
        FAC.Print(false, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('not_allowed', '%{red}/anticheat%{reset}'))
        return
    end

    local isConsole = FAC.IsConsole(source)

    if (args == nil or string.lower(type(args)) ~= 'table' or #args <= 0 or string.lower(tostring(args[1])) == 'help') then
        FAC.Commands['help'].func(isConsole, {})
        return
    end

    local command = string.lower(tostring(args[1]))

    for key, data in pairs(FAC.Commands) do
        if (string.lower(key) == command) then
            local param = args[2] or nil
            data.func(isConsole, param)
            return
        end
    end

    FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('command') .. ' %{red}/anticheat ' .. command .. ' %{white}' .. _('command_not_found'))
end)

FAC.Commands['reload'] = {
    description = _('command_reload'),
    func = function(isConsole)
        FAC.LoadBanList()
        FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('banlist_reloaded'))
    end
}

FAC.Commands['ip-reload'] = {
    description = _('ips_command_reload'),
    func = function(isConsole)
        FAC.LoadWhitelistedIPs()
        FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ips_reloaded'))
    end
}

FAC.Commands['ip-add'] = {
    description = _('ips_command_add'),
    func = function(isConsole, ip)
        if (FAC.AddIPToWhitelist(ip)) then
            FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_added', ip))
        else
            FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_invalid', ip))
        end
    end
}

FAC.Commands['total'] = {
    description = _('command_total'),
    func = function(isConsole)
        FAC.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('total_bans', #FAC.PlayerBans))
    end
}

FAC.Commands['help'] = {
    description = _('command_help'),
    func = function(isConsole)
        local string = '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('available_commands') .. '\n %{black}--------------------------------------------------------------\n'

        for command, data in pairs(FAC.Commands) do
            string = string .. '%{red}/anticheat ' .. command .. ' %{black}| %{white}' .. data.description .. '\n'
        end

        string = string .. '%{black}--------------------------------------------------------------%{reset}'

        FAC.Print(isConsole, string)
    end
}

FAC.Print = function(isConsole, string)
    if (isConsole) then
        FAC.PrintToConsole(string)
    else
        FAC.PrintToUser(string)
    end
end

FAC.PlayerAllowed = function(playerId)
    local isConsole = FAC.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (IsPlayerAceAllowed(playerId, 'freedomanticheat.commands')) then
        return true
    end

    return false
end

FAC.IgnorePlayer = function(playerId)
    local isConsole = FAC.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (not FAC.Config.BypassEnabled) then
        return false
    end

    if (IsPlayerAceAllowed(playerId, 'freedomanticheat.bypass')) then
        return true
    end

    return false
end
