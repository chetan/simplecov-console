require 'terminal-table'
require 'ansi/code'

class SimpleCov::Formatter::Console

  VERSION = IO.read(File.expand_path("../../VERSION", __FILE__)).strip

  ATTRIBUTES = [:table_options, :use_colors]
  class << self
    attr_accessor(*ATTRIBUTES)
  end

  # enable colors unless NO_COLOR=1
  SimpleCov::Formatter::Console.use_colors =
    (ENV['NO_COLOR'].nil? or ENV['NO_COLOR'].empty?) ? true : false

  def format(result)

    root = nil
    if Module.const_defined? :ROOT then
      root = ROOT
    elsif Module.const_defined?(:Rails) && Rails.respond_to?(:root) then
      root = Rails.root.to_s
    elsif ENV["BUNDLE_GEMFILE"] then
      root = File.dirname(ENV["BUNDLE_GEMFILE"])
    else
      root = Dir.pwd
    end

    puts
    puts "COVERAGE: #{colorize(pct(result))} -- #{result.covered_lines}/#{result.total_lines} lines in #{result.files.size} files"
    puts

    if root.nil? then
      return
    end

    files = result.files.sort{ |a,b| a.covered_percent <=> b.covered_percent }

    covered_files = 0
    files.select!{ |file|
      if file.covered_percent == 100 then
        covered_files += 1
        false
      else
        true
      end
    }

    if files.nil? or files.empty? then
      return
    end

    table = files.map do |f|
      [
        colorize(pct(f)),
        f.filename.gsub(root + "/", ''),
        f.lines_of_code,
        f.missed_lines.count,
        missed(f.missed_lines).join(", ")
      ]
    end

    if table.size > 15 then
      puts "showing bottom (worst) 15 of #{table.size} files"
      table = table.slice(0, 15)
    end

    table_options = SimpleCov::Formatter::Console.table_options || {}
    if !table_options.kind_of?(Hash) then
      raise ArgumentError.new("SimpleCov::Formatter::Console.table_options must be a Hash")
    end
    headings = %w{ coverage file lines missed missing }

    opts = table_options.merge({:headings => headings, :rows => table})
    t = Terminal::Table.new(opts)
    puts t

    if covered_files > 0 then
      puts "#{covered_files} file(s) with 100% coverage not shown"
    end

  end

  def missed(missed_lines)
    groups = {}
    base = nil
    previous = nil
    missed_lines.each do |src|
      ln = src.line_number
      if base && previous && (ln - 1) == previous
        groups[base] += 1
        previous = ln
      else
        base = ln
        groups[base] = 0
        previous = base
      end
    end

    group_str = []
    groups.map do |starting_line, length|
      if length > 0
        group_str << "#{starting_line}-#{starting_line + length}"
      else
        group_str << "#{starting_line}"
      end
    end

    group_str
  end

  def pct(obj)
    sprintf("%6.2f%%", obj.covered_percent)
  end

  def use_colors?
    SimpleCov::Formatter::Console.use_colors
  end

  def colorize(s)
    return s if !use_colors?

    s =~ /([\d.]+)/
    n = $1.to_f
    if n >= 90 then
      ANSI.green { s }
    elsif n >= 80 then
      ANSI.yellow { s }
    else
      ANSI.red { s }
    end
  end

end
