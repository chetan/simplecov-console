
require 'hirb'
require 'colorize'

class SimpleCov::Formatter::Console

  VERSION = File.new(File.join(File.expand_path(File.dirname(__FILE__)), "../VERSION")).read.strip

  def format(result)

    root = nil
    if Module.const_defined? :ROOT then
      root = ROOT
    elsif Module.const_defined? :Rails then
      root = Rails.root.to_s
    elsif ENV["BUNDLE_GEMFILE"] then
      root = File.dirname(ENV["BUNDLE_GEMFILE"])
    else
      root = Dir.pwd
    end

    puts
    puts "COVERAGE: #{colorize(pct(result))} -- #{result.covered_lines}/#{result.total_lines} lines"
    puts

    if root.nil? then
      return
    end

    files = result.files.sort{ |a,b| a.covered_percent <=> b.covered_percent }

    files.select!{|file| file.covered_percent < 100 }

    if files.nil? or files.empty? then
      return
    end

    table = files.map{ |f| { :file => f.filename.gsub(root + "/", ''), :coverage => pct(f) } }

    if table.size > 15 then
      puts "showing bottom (worst) 15 of #{table.size} files"
      table = table.slice(0, 15)
    end

    s = Hirb::Helpers::Table.render(table).split(/\n/)
    s.pop
    puts s.join("\n").gsub(/\d+\.\d+%/) { |m| colorize(m) }

  end

  def pct(obj)
    sprintf("%6.2f%%", obj.covered_percent)
  end

  def colorize(s)
    s =~ /([\d.]+)/
    n = $1.to_f
    if n >= 90 then
      s.colorize(:green)
    elsif n >= 80 then
      s.colorize(:yellow)
    else
      s.colorize(:red)
    end
  end

end
