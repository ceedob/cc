net = peripheral.wrap("back")
monitor = peripheral.wrap("top")
monitor.setTextScale(0.5)
monitor.setCursorPos(1,1)
lastpower = 0
initializing = true
powers = {}
for i=1, 20 do
  powers[i] = 0
end
i = 1

function avg()
	local total = 0
	for i=1, 20 do
	  total = total + powers[i]
	end
	return total / 20
end

while true do
  batbox_power = net.callRemote("batbox_0","getEUStored")
  cesu_power = net.callRemote("cesu_0","getEUStored")
  power = (batbox_power + cesu_power) -- of 340000 EU
  monitor.clear()
  monitor.setCursorPos(1,1)
  monitor.write(textutils.formatTime(os.time(),false))
  monitor.setCursorPos(1,2)
  if power < 1000 then
  	monitor.write("Power: Empty")
  elseif power > 330000 then
  	monitor.write("Power: Full")
  else
  	monitor.write("Power: " .. math.floor(power/3400) .. "%")
  end
  monitor.setCursorPos(8,3)
  monitor.write(power .. "EU")
  monitor.setCursorPos(1,4)
  local pertick = math.ceil((power - lastpower)/10)
  if pertick < 0 then
    monitor.write("Consumption: " .. -1 * pertick .. "/t")
  else
    monitor.write("Production:  " .. pertick .. "/t")
  end
   monitor.setCursorPos(1,5)
  if initializing then
  	monitor.write("Initializing Average ..." .. (i-1) / 20 .. "%")
  else
    if avg() < 0 then
      monitor.write("Avg Consumption (10sec): " .. -1 * avg() .. "/t")
    else
      monitor.write("Avg Production (10sec): " .. avg() .. "/t")
    end
  end
  powers[i] = pertick

  sleep(0.5)

  i = (i + 1) % 20 + 1
  print(i)
  if i == 20 then
  	initializing = false
  end
  lastpower = power
end