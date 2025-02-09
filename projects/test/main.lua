local Database = require("data.Database")

local fooDb = Database:new("test/fooDb")

local id = fooDb:create({ foo = "hi" })
fooDb:update(id, { foo = "bar" })

print(textutils.serialize(fooDb:listAll()))
