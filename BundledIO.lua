local tArgs = {...}
if not tArgs[1] then
  error("Please enter in a side!")
end
local tobin = function(count)
  local out = ""
  while count > 0 do
    local r = count%2
    count = math.floor(count/2)
    if r == 0 then
      out = "0"..out
    else
      out = "1"..out
    end
  end
  return out
end
local todec = function(inp)
  local out = 0
  while string.len(inp) > 0 do
    out = out*2
    if string.sub(inp,1,1) == "1" then
      out = out+1
    end
    inp = string.sub(inp,2)
  end
  return out
end
local drawStrip = function(inp)
  inp = string.rep("0",16-string.len(inp))..inp
  for i = 16,1,-1 do
    if string.sub(inp,i,i) == "1" then
      term.setBackgroundColor(colors.white)
    else
      term.setBackgroundColor(colors.black)
    end
    term.write(" ")
  end
end
local hud = function()
  term.setTextColor(colors.white)
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  term.setBackgroundColor(colors.gray)
  term.write(string.rep("=",17))
  term.setCursorPos(1,5)
  term.write(string.rep("=",17))
  term.setCursorPos(17,2)
  term.write("I")
  term.setCursorPos(17,3)
  term.write(" ")
  term.setCursorPos(17,4)
  term.write("O")
  term.setCursorPos(1,3)
  term.blit(string.rep(" ",16),string.rep("f",16),"0123456789abcdef")
end
local updateRs = function()
  local inp = tobin(rs.getBundledInput(tArgs[1]))
  local out = tobin(rs.getBundledOutput(tArgs[1]))
  term.setCursorPos(1,2)
  drawStrip(inp)
  term.setCursorPos(1,4)
  drawStrip(out)
end
hud()
updateRs()
while true do
  local e,a,b,c = os.pullEvent()
  if e == "redstone" then
    updateRs()
  end
  if e == "mouse_click" and a == 1 and c == 4 and b < 17 then
    b = 17-b
    local inp = tobin(rs.getBundledOutput(tArgs[1]))
    inp = string.rep("0",16-string.len(inp))..inp
    if string.sub(inp,b,b) == "1" then
      inp = string.sub(inp,1,b-1).."0"..string.sub(inp,b+1,16)
    else
      inp = string.sub(inp,1,b-1).."1"..string.sub(inp,b+1,16)
    end
    rs.setBundledOutput(tArgs[1],todec(inp))
    updateRs()
  end
end
