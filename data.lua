local fakePlayer = table.deepcopy(data.raw["character"]["character"])
fakePlayer.name = "brittle-machines-fake-player"

data:extend({
    fakePlayer,
})
