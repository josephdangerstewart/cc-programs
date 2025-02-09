# Database

A simple abstraction for working with persistent data. Functionally a document database stored to disk and kept in memory. Returned data is safe to mutate.

## Usage

```lua
local Database = require("data.Database")

local fooDb = Database:new("path/to/foo.db") -- .db extension is optional (if omitted, it will be automatically added)

local id, data = fooDb:create({ foo = "bar" }) -- Data passed in here should be safe to serialize. Metatables will be discarded and recursive properties will cause errors.

data.foo = "baz" -- Mutations are safe

fooDb:listAll() -- Returns a key-value pair table
fooDb:enumerateAll() -- Returns an enumerator for use in for loops

fooDb:update(id, data) -- Returns false, errorMessage on failure and true on success

fooDb:delete(id) -- Deletes the item from the database
```
