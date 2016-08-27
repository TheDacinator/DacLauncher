--Variables
local song = nil
local drive = peripheral.find("tape_drive")
if not drive then
  error("No Tape Drive Attatched!")
end
if not drive.isReady() then
  error("No Tape Inserted!")
end
local x,y = term.getSize()
local speed = 1.5
drive.setSpeed(speed)
--Functions
local newline = function()
  local x,y = term.getCursorPos()
  term.setCursorPos(1,y+1)
end
local popup = function(text)
  paintutils.drawBox(1,1,x,y,colors.purple)
  paintutils.drawFilledBox(2,2,x-1,y-1,colors.orange)
  term.setCursorPos((x-string.len(text))/2+1,3)
  term.setTextColor(colors.white)
  term.setBackgroundColor(colors.orange)
  term.write(text)
  term.setCursorPos(3,y-2)
  return read()
end
local drawOptions = function()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.write("Name: "..tostring(drive.getLabel()))
  newline()
  term.write("Playback Speed: "..speed)
  newline()
  term.write("Write")
  newline()
  term.write("Play")
  newline()
  term.write("Pause")
  newline()
  term.write("Stop")
  newline()
  term.write("Exit")
end
--Code
while true do
  drawOptions()
  local e,a,b,c = os.pullEvent()
  if e == "mouse_click" then
    if c == 1 then
      drive.setLabel(popup("Enter the new label"))
    elseif c == 2 then
      speed = tonumber(popup("Enter in the new playback speed or sample rate"))
      if speed > 2 then
        speed = (speed/32768)*1.5
      end
      drive.setSpeed(speed)
    elseif c == 3 then
      local page = popup("Enter in URL to download from")
      if http.checkURL(page) then
        page = http.get(page)
      elseif fs.exists(page) then
        page = fs.open(page,"r")
      else
        page = nil
      end
      song = page.readAll()
      term.setTextColor(colors.white)
      term.setBackgroundColor(colors.black)
      term.clear()
      term.setCursorPos(1,1)
      term.write("Writing...")
      drive.stop()
      drive.seek(0-drive.getSize())
      local i = 1
      if page and string.len(page) <= drive.getSize() then
        while true do
          for j = 1,1000 do
            drive.write(string.byte(string.sub(song,i,i)))
            i = i+1
            if i > string.len(song) then
              break
            end
          end
          if i > string.len(song) then
            break
          end
          sleep(0)
        end
      end
      term.clear()
      term.setCursorPos(1,1)
      if string.len(size) > drive.getSize() then
        term.write("Song Too Large!")
      else
        term.write("Done!")
      end
      sleep(1)
    elseif c == 4 then
      drive.play(song)
    elseif c == 5 then
      drive.stop()
    elseif c == 6 then
      drive.stop()
      drive.seek(0-drive.getSize())
    elseif c == 7 then
      break
    end
  end
end
