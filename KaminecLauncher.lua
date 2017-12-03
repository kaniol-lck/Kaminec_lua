require("LAminec.class")

require("LAminec.Game")
require("LAminec.Profile")
require("LAminec.JsonManager")

t = os.clock()

profile = loadProfile()

game = Game.new(profile)

game:start()

print (os.clock() - t)