if not http then
  error("Http api not enabled!")
end
local page = http.get("https://raw.githubusercontent.com/TheDacinator/DacLauncher/master/DacLauncher2")
local file = fs.open("DacLauncherDontRun,"w")
file.write(page.readAll())
file.close()
page.close()
shell.run("DacLauncherDontRun")
