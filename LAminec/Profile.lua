function Profile(mode, playerName, lastVersionId, gamePath, corePath)

	return {
		mode = mode,
		playerName = playerName,
		lastVersionId = lastVersionId,
		gamePath = gamePath,
		corePath = corePath}
end

require("LAminec.info")
require("LAminec.utility")

function loadProfile()

	return Profile(info.mode,
	               info.playerName,
				   info.lastVersionId,
				   info.gamePath,
				   info.corePath)
end
