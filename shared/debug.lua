local sharedConfig = require 'shared.config'

function Debug(...)
    if sharedConfig.debugMode then
        lib.print.info(...)
    end
end
