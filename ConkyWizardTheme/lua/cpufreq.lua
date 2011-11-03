function conky_cpu_freq_max_g(cpu)
  local freq = tonumber(conky_parse(string.format('${head /sys/devices/system/cpu/cpu%d/cpufreq/scaling_max_freq 1}', cpu)));  
  return string.format('%0.2f', freq / 1000000);
end

function conky_cpu_freq_g(cpu)
  local freq = tonumber(conky_parse(string.format('${head /sys/devices/system/cpu/cpu%d/cpufreq/scaling_cur_freq 1}', cpu)));
  return string.format('%0.2f', freq / 1000000);
end