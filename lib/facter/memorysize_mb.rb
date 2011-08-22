# As seen in: http://groups.google.com/group/puppet-users/browse_thread/thread/f1c0689dad937853/095d3109f1a8b284

require 'facter'

{
  :MemorySizeRaw => "MemTotal",
  :MemoryFreeRaw => "MemFree",
  :SwapSizeRaw   => "SwapTotal",
  :SwapFreeRaw   => "SwapFree"
}.each do |fact, name|

  Facter.add(fact) do
    confine :kernel => :linux
    setcode do
      memsize_raw = ""
      Thread::exclusive do
        File.readlines("/proc/meminfo").each do |l|
          memsize_raw = $1.to_i if l =~ /^#{name}:\s+(\d+)\s+\S+/
          # MemoryFree == memfree + cached + buffers
          #  (assume scales are all the same as memfree)
          if name == "MemFree" &&
              l =~ /^(?:Buffers|Cached):\s+(\d+)\s+\S+/
            memsize_raw += $1.to_i
          end
        end
      end
      memsize_raw
    end
  end
end
