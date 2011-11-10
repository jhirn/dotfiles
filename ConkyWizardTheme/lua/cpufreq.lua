function conky_cpu_freq_max_g(cpu)
  local freq = tonumber(conky_parse(string.format('${head /sys/devices/system/cpu/cpu%d/cpufreq/scaling_max_freq 1}', cpu)));  
  return string.format('%0.2f', freq / 1000000);
end

function conky_cpu_freq_g(cpu)
  local freq = tonumber(conky_parse(string.format('${head /sys/devices/system/cpu/cpu%d/cpufreq/scaling_cur_freq 1}', cpu)));
  return string.format('%0.2f', freq / 1000000);
end

function conky_battery_remaining()
  return string.match(conky_parse('${exec acpi -b}'),"(%d:%d%d:%d%d)");
end

function conky_battery_voltage()
  return string.match(conky_parse('${exec cat /proc/acpi/battery/BAT0/state}'),"(%d+ mW)");
end