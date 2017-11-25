require("LAminec.class")

require("LAminec.Game")
require("LAminec.Profile")
require("LAminec.JsonManager")

profile = loadProfile()

game = Game.new(profile)

game:start()
