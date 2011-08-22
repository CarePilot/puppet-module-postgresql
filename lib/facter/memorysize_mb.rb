# As seen in: http://groups.google.com/group/puppet-users/browse_thread/thread/f1c0689dad937853/095d3109f1a8b284

require 'facter'
Facter.add("memorysize_mb") do
  confine :kernel => :Linux
  ram = 0
  # Steal linux's meminfo
  File.open( "/proc/meminfo" , 'r' ) do |f|
    f.grep( /^MemTotal:/ ) { |mem|
      ram = mem.split( / +/ )[1].to_i / 1024
    }
  end
  setcode do
    ram
  end
end
