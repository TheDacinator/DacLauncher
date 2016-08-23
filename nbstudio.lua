--Variables
local x,y = term.getSize()
local song = {["len"]=100,["tempo"] = 120,["author"] = '',["name"] = ""}
local scroll = 0
local xscroll = 0
local textnote = "right"
local note = peripheral.wrap(textnote)
local screen = 1
local nbs = {}
local notedic = {[0]="e#F","eG","eG#","eA","eA#","eB","eC","eC#","eD","eD#","eE","eF","eF#","1G","1G#","1A","1A#","1B","1C","1C#","1D","1D#","1E","1F","1F#"}
local insdic = {["s"] = "eSound Effect",[0] = "1Harp","2Bass Drum","3Snare","4Hat","5Bass Attack"}
--Functions
local desc = function(inp,type)
  term.setCursorPos(2,1)
  local dic = nil
  if type == 1 then
    dic = notedic
  else
    dic = insdic
  end
  term.setBackgroundColor(colors.gray)
  if string.sub(dic[inp],1,1) == "e" then
    term.setTextColor(colors.red)
  elseif string.sub(dic[inp],1,1) == "1" then
    term.setTextColor(colors.orange)
  elseif string.sub(dic[inp],1,1) == "2" then
    term.setTextColor(colors.magenta)
  elseif string.sub(dic[inp],1,1) == "3" then
    term.setTextColor(colors.lightBlue)
  elseif string.sub(dic[inp],1,1) == "4" then
    term.setTextColor(colors.yellow)
  elseif string.sub(dic[inp],1,1) == "5" then
    term.setTextColor(colors.lime)
  end
  term.write(string.sub(dic[inp],2))
end
local rennum = function(inp)
  if inp < 10 then
    return inp
  else
    return string.char(inp+87)
  end
end
local drawEdit = function()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.write(string.rep(" ",x))
  term.setCursorPos(math.ceil(x/2),1)
  term.write("^")
  term.setCursorPos(x-3,1)
  term.write("<  >")
  term.setCursorPos(1,y)
  term.write(string.rep(" ",x))
  term.setCursorPos(math.ceil(x/2),y)
  term.write("v")
  term.setCursorPos(x-6,y)
  term.setTextColor(colors.green)
  term.write("Options")
  term.setTextColor(colors.red)
  term.setCursorPos(1,y)
  term.write("Close")
end
local drawNotes = function()
  for i = 2,y-1,1 do
    term.setCursorPos(1,i)
    if song[i-1+scroll] then
      if song[i-1+scroll]["ins"] == "s" then
        term.blit("s","e","9")
      else
        term.blit(tostring(song[i-1+scroll]["ins"]),tostring(song[i-1+scroll]["ins"]+1),"7")
      end
      local a = nil
      for j = 1,x-1,1 do
        if song[i-1+scroll][xscroll+j] then
          if song[i-1+scroll][xscroll+j] > 12 then
            a = "1"
          else
            a = "e"
          end
          term.blit(tostring(rennum(song[i-1+scroll][xscroll+j])),"0",a)
        else
          term.blit("=","7","f")
        end
      end
    else
      term.blit("|","8","7")
    end
  end
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.red)
  if song["len"]-xscroll <= x and song["len"]-xscroll > 1 then
    for i = 2,y-1 do
      term.setCursorPos(song["len"]-xscroll,i)
      term.write("|")
    end
  end
end
incrementNote = function(inp,scrl,t)
  local maxn = 0
  if t == 1 then
    maxn = 24
  else
    maxn = 4
  end
  if inp == 0 and scrl == -1 then
    if t == 1 then
      return nil
    else
      return "s"
    end
  elseif inp == nil or inp == "s" then
    if scrl == -1 then
      return maxn
    else
      return 0
    end
  elseif inp == maxn and scrl == 1 then
    if t == 1 then
      return nil
    else
      return "s"
    end
  else
    return inp + scrl
  end
end
local popup = function(text)
  local win = nil
  if x > 51 and y > 19 then
    win = window.create(term.current(),(x-51)/2+1,(y-19)/2+1,51,19)
  else
    win = window.create(term.current(),1,1,x,y)
  end
  local winx,winy = win.getSize()
  win.setCursorPos(1,1)
  win.write(string.rep("X",winx))
  win.setCursorPos(1,winy)
  win.write(string.rep("X",winx))
  for i = 2,winy-1,1 do
    win.setCursorPos(1,i)
    win.write("X"..string.rep(" ",winx-2).."X")
  end
  win.setCursorPos((winx-string.len(text))/2+1,3)
  win.write(text)
  win.setCursorPos(3,winy-2)
  local out = read()
  win.setVisible(false)
  return out
end
local playNote = function(nx,ny,ins)
  local n = nil
  if ins then
    n = peripheral.wrap(ins)
  else
    n = note
  end
  if song[ny-1+scroll] and song[ny-1+scroll][nx-1+xscroll] then
    if song[ny-1+scroll]["ins"] == "s" and song[ny-1+scroll]["sound"] then
      n.playSound(song[ny-1+scroll]["sound"],1,song[ny-1+scroll][nx-1+xscroll])
    elseif song[ny-1+scroll]["ins"] ~= "s" then
      n.playNote(song[ny-1]["ins"],song[ny-1+scroll][nx-1+xscroll])
    end
  end
end
local largestnum = function(tbl)
  local out = 0
  for key,value in pairs(tbl) do
    if type(key) == "number" and key > out then
      out = key
    end
  end
  return out
end
local drawOptions = function()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.white)
  term.setCursorPos(1,1)
  term.setTextColor(colors.lightBlue)
  term.write("Tempo: "..song["tempo"].." bpm")
  term.setCursorPos(1,2)
  term.setTextColor(colors.orange)
  term.write("Editing Noteblock: "..textnote)
  term.setCursorPos(1,3)
  term.setTextColor(colors.lime)
  term.write("Song Name: "..song["name"])
  term.setCursorPos(1,4)
  term.setTextColor(colors.blue)
  term.write("Author: "..song["author"])
  term.setCursorPos(1,5)
  term.setTextColor(colors.brown)
  term.write("Edit Playback Noteblocks")
  term.setCursorPos(1,6)
  term.setTextColor(colors.red)
  term.write("Save")
  term.setCursorPos(1,7)
  term.setTextColor(colors.magenta)
  term.write("Load")
  term.setCursorPos(1,8)
  term.setTextColor(colors.cyan)
  term.write("Play")
  term.setCursorPos(1,9)
  term.setTextColor(colors.yellow)
  term.write("Exit")
  term.setCursorPos(1,10)
  term.setTextColor(colors.lightBlue)
  term.write("New")
end
local drawNbs = function()
  term.setTextColor(colors.orange)
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  term.write("Playback Noteblocks:")
  term.setCursorPos(1,2)
  term.setTextColor(colors.lightGray)
  for i = 1,#nbs,1 do
    term.write("  "..nbs[i])
    term.setCursorPos(1,i+2)
  end
  term.setTextColor(colors.cyan)
  term.write("Add")
  local cx,cy = term.getCursorPos()
  term.setCursorPos(1,cy+1)
  term.setTextColor(colors.red)
  term.write("Exit")
end
local playSong = function()
  local nbnum = 1
  for j = 1,song["len"] do
    for i = 1,table.maxn(song) do
      if song[i] and song[i][j] then
        playNote(j+1-xscroll,i+1-scroll,nbs[math.floor(nbnum)])
        nbnum = nbnum + 0.25
        if math.floor(nbnum) > #nbs and math.floor(nbnum) > 1 then
          break
        end
      end
    end
    nbnum = 1
    sleep(60/song["tempo"])
  end
end
--Code
term.clear()
drawEdit()
drawNotes()
local condition = true
while condition do
  local event,a,b,c,d = os.pullEventRaw()
  if event == "terminate" then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1,1)
    break
  end
  if event == "mouse_click" and a == 1 then
    if b >= x-6 and c == y then
      screen = 2
      drawOptions()
      local condition = true
      while condition do
        local event,a,b,c = os.pullEvent("mouse_click")
        if a == 1 then
          if c == 1 then
            song["tempo"] = popup("Enter in the new tempo (bpm).")
            drawOptions()
          elseif c == 2 then
            textnote = popup("Enter in the new noteblock for editing.")
            note = peripheral.wrap(textnote)
            drawOptions()
          elseif c == 3 then
            song["name"] = popup("Enter in the new name.")
            drawOptions()
          elseif c == 4 then
            song["author"] = popup("Enter in the new author.")
            drawOptions()
          elseif c == 5 then
            drawNbs()
            while true do
              local event,a,b,c = os.pullEvent()
              if a == 1 then
                if c >= 2 and c <= #nbs+1 and string.lower(popup("Delete this noteblock? (Y/N)")) == "y" then
                  table.remove(nbs,c-1)
                  drawNbs()
                elseif c == #nbs+2 then
                  table.insert(nbs,popup("Enter in the new noteblock peripheral."))
                  drawNbs()
                elseif c == #nbs+3 then
                  drawOptions()
                  break
                end
              end
            end
          elseif c == 6 then
            local save = fs.open(popup("Enter in the directory to save."),"w")
            if save then
              save.write(textutils.serialize(song))
            end
            save.close()
            drawOptions()
          elseif c == 7 then
            local a = popup("Enter in the directory to load.","r")
            if fs.exists(a) then
              local load = fs.open(a,"r")
              song = textutils.unserialize(load.readAll())
              load.close()
            end
            drawOptions()
          elseif c == 8 then
            playSong()
          elseif c == 9 then
            drawEdit()
            drawNotes()
            break
          elseif c == 10 then
            song = {["len"]=100,["tempo"]=120,["name"]="",['author']=''}
          end
        end
      end
    elseif c == y and largestnum(song) > y-4+scroll then
      scroll = scroll+1
      drawEdit()
      drawNotes()
    elseif b == 1 and c < y and c > 1 then
      if not song[c-1+scroll] then
        song[c-1+scroll] = {}
        song[c-1+scroll]["ins"] = 0
        drawEdit()
        drawNotes()
        desc(song[c-1+scroll]["ins"],2)
      else
        if string.lower(popup("Delete This Track? (Y/N)")) == "y" then
          song[c-1+scroll] = nil
        end
        drawEdit()
        drawNotes()
      end
    elseif c == 1 and b <= x-4 and scroll > 0 then
      scroll = scroll-1
      drawEdit()
      drawNotes()
    elseif c == 1 and b >= x-1 then
      xscroll = xscroll+1
      drawEdit()
      drawNotes()
    elseif c == 1 and b >= x-3 and xscroll ~= 0 then
      xscroll = xscroll-1
      drawEdit()
      drawNotes()
    end
  end
  if event == "mouse_scroll" and b > 1 and b < x and c > 1 and c < y and song[c-1+scroll] then
    song[c-1+scroll][b-1+xscroll] = incrementNote(song[c-1+scroll][b-1+xscroll],a*-1,1)
    drawNotes()
    if song[c-1+scroll][b-1+xscroll] then
      playNote(b,c)
      drawEdit()
      drawNotes()
      desc(song[c-1+scroll][b-1+xscroll],1)
    end
  end
  if event == "mouse_click" and a == 2 and b == 1 and c < y and c > 1 and song[c-1+scroll] and song[c-1+scroll]["ins"] == "s" then
    song[c-1+scroll]["sound"] = popup("Enter in the new sound location")
    drawEdit()
    drawNotes()
    desc(song[c-1+scroll]["ins"],2)
  end
  if event == "mouse_click" and b > 1 and c > 1 and c < y and song[c-1+scroll] then
    if a == 1 then
      song[c-1+scroll][b-1+xscroll] = nil
      drawNotes()
    elseif a == 2 then
      playNote(b,c)
      drawEdit()
      drawNotes()
      if song[c-1+scroll][b-1+xscroll] then
      desc(song[c-1+scroll][b-1+xscroll],1)
      end
    end
  end
  if event == "mouse_scroll" and b == 1 then
    if not song[c-1+scroll] then
      song[c-1+scroll] = {}
    end
    song[c-1+scroll]["ins"] = incrementNote(song[c-1+scroll]["ins"],a*-1,2)
    drawEdit()
    drawNotes()
    desc(song[c-1+scroll]["ins"],2)
  end
  if event == "mouse_click" and a == 3 and c > 1 and c < y and b > 1 then
    song["len"] = b+xscroll
    drawEdit()
    drawNotes()
  end
  if event == "mouse_click" and a == 2 and b == 1 and c > 1 and c < y then
    drawEdit()
    drawNotes()
    desc(song[c-1+scroll]["ins"],2)
  end
  if event == "mouse_click" and a == 1 and b <= 5 and c == y then
    break
  end
  if event == "redstone" then
    playSong()
    rs.setOutput("back",true)
    sleep(0.2)
    rs.setOutput("back",false)
  end
  sleep(0)
end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
