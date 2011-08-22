# Saith the PostgreSQL manual on max_stack_depth:
#
#   The ideal setting for this parameter is the actual stack size
#   limit enforced by the kernel (as set by ulimit -s or local
#   equivalent), less a safety margin of a megabyte or so.
#
# This fact produces ulimit -s.

require 'facter'

Facter.add('stack_depth') do
  setcode do
    %x{ulimit -s}.chomp
  end
end
