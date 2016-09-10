if not http then
  error("Http api not enabled!"
end
local file = http.get("https://raw.githubusercontent.com/TheDacinator/DacLauncher/master/DacLauncher2")
loadstring(file.readAll())()
