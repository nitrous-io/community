#=require supports/sinon-1.15.0.js
#=require supports/sinon-server-1.15.0.js

# set the Mocha test interface
# see http://mochajs.org/#interfaces
mocha.ui('bdd')

# ignore the following globals during leak detection
mocha.globals(['YUI'])

# or, ignore all leaks
mocha.ignoreLeaks()

# set slow test timeout in ms
mocha.timeout(5)

# Show stack trace on failing assertion.
chai.config.includeStack = true