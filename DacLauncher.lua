--Variables
local x,y = term.getSize()
local myfiletable = nil
if fs.exists("updates") then
  local f = fs.open("updates","r")
  myfiletable = textutils.unserialize(f.readAll())
  f.close()
else
  local f = fs.open("updates","w")
  f.write("{}")
  myfiletable = {}
  f.close()
end
--Functions
local fadein = function()
  paintutils.drawFilledBox(1,1,x,y,colors.gray)
  sleep(0.1)
  paintutils.drawFilledBox(1,1,x,y,colors.lightGray)
  sleep(0.1)
  paintutils.drawFilledBox(1,1,x,y,colors.white)
end
local centertext = function(t,m,p)
  local x,y = term.getSize()
  if t == 1 then
    term.setCursorPos((x-string.len(m))/2+1,p)
    term.write(m)
  elseif t == 2 then
    term.setCursorPos((x-string.len(m))/2+1,(y/2)+1)
    term.write(m)
  end
end
local loadingbar = function()
  local counter = 0
  while true do
    counter = counter + 1
    if counter == 5 then
      counter = 0
    end
    term.setCursorPos(3,4)
    for i = 3,x-2 do
      if math.fmod(term.getCursorPos()+counter,5) == 0 then
        term.blit("=","d","8")
      else
        term.blit("=","7","8")
      end
    end
    sleep(0.2)
  end
end
local filetable = nil
local manageFiles = function()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.gray)
  term.setCursorPos(3,6)
  term.write("Checking File Servers...")
  local files = http.get("https://raw.githubusercontent.com/TheDacinator/DacLauncher/master/updates")
  filetable = textutils.unserialize(files.readAll())
  files.close()
  if #myfiletable < #filetable then
    for i = #myfiletable+1,#filetable do
      myfiletable[i] = {filetable[i][1],filetable[i][2],0}
    end
    local f = fs.open("updates","w")
    f.write(textutils.serialize(myfiletable))
    f.close()
  end
  for i = 1,#myfiletable do
    if not fs.exists(myfiletable[i][2]) then
      myfiletable[i][3] = 0
    end
  end
  local f = fs.open("updates","w")
  f.write(textutils.serialize(myfiletable))
  f.close()
  while true do
    paintutils.drawFilledBox(1,5,x,y,colors.white)
    term.setTextColor(colors.green)
    term.setCursorPos(1,y)
    term.write("Version: "..myfiletable[1][3])
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.gray)
    term.setCursorPos(3,6)
    for i = 1,#filetable do
      if myfiletable[i][3] == 0 then
        term.blit("# ","ee","00")
      elseif myfiletable[i][3] < filetable[i][3] or (myfiletable[i][3] == 0 and fs.exists(myfiletable[i][2])) then
        term.blit("# ","44","00")
      elseif myfiletable[i][3] == filetable[i][3] then
        term.blit("# ","55","00")
      end
      term.write(filetable[i][2])
      term.setCursorPos(3,6+i)
    end
    term.setTextColor(colors.red)
    term.write("Exit")
    local e,a,b,c = os.pullEvent("mouse_click")
    if c > 5 and c < #filetable+6 and myfiletable[c-5][3] < filetable[c-5][3] then
      paintutils.drawFilledBox(1,5,x,y,colors.white)
      term.setCursorPos(3,6)
      term.setTextColor(colors.gray)
      term.write("Update? (y/n)")
      local e,f = os.pullEvent("char")
      if f == "y" then
        term.setCursorPos(3,6)
        term.write("Updating...  ")
        local file = http.get(filetable[c-5][1])
        local program = file.readAll()
        file.close()
        file = fs.open(filetable[c-5][2],"w")
        file.write(program)
        file.close()
        myfiletable[c-5][3] = filetable[c-5][3]
        local file = fs.open("updates","w")
        file.write(textutils.serialize(myfiletable))
        file.close()
        sleep(1)
        term.setCursorPos(3,6)
        term.setTextColor(colors.lime)
        term.write("Done!      ")
        sleep(1)
      end
    elseif c == #filetable+6 then
      break
    end
  end
end
--Code
fadein()
term.setBackgroundColor(colors.white)
term.setTextColor(colors.green)
centertext(1,"DacLauncher",2)
paintutils.drawFilledBox(1,4,x,4,colors.lightGray)
parallel.waitForAny(loadingbar,manageFiles)
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
