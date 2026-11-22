const HOST = "sieve_launcher";

async function launch() {
  try {
    const reply = await browser.runtime.sendNativeMessage(HOST, { action: "launch" });
    if (!reply || !reply.ok) {
      console.error("Sieve launcher failed:", reply && reply.error);
    }
  } catch (e) {
    console.error("Could not reach native helper '" + HOST + "':", e);
  }
}

browser.action.onClicked.addListener(launch);
browser.commands.onCommand.addListener((cmd) => {
  if (cmd === "launch-sieve") launch();
});
