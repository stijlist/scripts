## unfinished; implement strip_leading_forward_slash and 
## add_trailing_done_tag
def taskpaper_format?(line)
  # find lines containing a @done tag
  (line =~ /@done/) != nil
end
def listary_format?(line)
  # find lines with a leading forward slash
  (line =~ /^\//) != nil
end

def convert(line)
  if listary_format?(line)
    line.strip_leading_forward_slash
    line.add_trailing_done_tag
  end
end

if ARGV.length != 0
  # there has to be a much cleaner way to do this
  lines = []
  ARGV.each do |arg|
    File.open(arg) do |f|
      while line = f.gets
        lines << line
      end
    end
    converted = convert(lines)
    File.open(arg, "w") do |f|
      converted.each do |t|
        f.puts(t)
      end
    end
  end
end
