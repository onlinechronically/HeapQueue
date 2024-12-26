Config = {
    identifier_type = "steam", -- this can be the type of identifier to use for users
    priority = {               -- this will be a table containing user identifiers to apply some level of priority to
        ["steam:debug"] = 3,
        ["steam:debugAlt"] = 2
    }
}
