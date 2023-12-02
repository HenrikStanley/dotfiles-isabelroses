import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";

export async function globals() {
    globalThis.options = (await import("../options.js")).default;
    globalThis.iconBrowser = (await import("../misc/IconBrowser.js")).default;
    globalThis.app = (
        await import("resource:///com/github/Aylur/ags/app.js")
    ).default;
    globalThis.audio = (
        await import("resource:///com/github/Aylur/ags/service/audio.js")
    ).default;
    globalThis.brightness = (await import("../services/brightness.js")).default;
    globalThis.indicator = (
        await import("../services/onScreenIndicator.js")
    ).default;
    Mpris.connect("player-added", (mpris, bus) => {
        mpris.getPlayer(bus)?.connect("changed", (player) => {
            globalThis.mpris = player || Mpris.players[0];
        });
    });
}