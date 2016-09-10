local cleanenv = getfenv()
if not http then
  error("Http api not enabled!")
end
local page = http.get("https://raw.githubusercontent.com/TheDacinator/DacLauncher/master/DacLauncher2")
local func = loadstring(page.readAll())
setfenv(func,cleanenv)
func()
page.close()
