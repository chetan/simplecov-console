require 'ansi/code'

class SimpleCov::Formatter::Console

  VERSION = IO.read(File.expand_path("../../VERSION", __FILE__)).strip

  ATTRIBUTES = [:table_options, :use_colors, :max_rows, :show_covered, :sort, :output_style]
  class << self
    attr_accessor(*ATTRIBUTES)
  end

  # enable colors unless NO_COLOR=1
  SimpleCov::Formatter::Console.use_colors =
    (ENV['NO_COLOR'].nil? or ENV['NO_COLOR'].empty?) ? true : false

  # configure max rows from MAX_ROWS env var
  SimpleCov::Formatter::Console.max_rows = ENV.fetch('MAX_ROWS', 15).to_i

  # configure show_covered from SHOW_COVERED env var
  SimpleCov::Formatter::Console.show_covered = ENV.fetch('SHOW_COVERED', 'false') == 'true'

  # configure sort from SORT env var
  SimpleCov::Formatter::Console.sort = ENV.fetch('SORT', 'coverage')

  # configure output format ('table', 'block')
  SimpleCov::Formatter::Console.output_style = ENV.fetch('OUTPUT_STYLE', 'table')

  def include_output_style
    if SimpleCov::Formatter::Console.output_style == 'block' then
      require 'simplecov-console/output/block'
      extend BlockOutput
    else
      # default to table
      require 'simplecov-console/output/table'
      extend TableOutput
    end
  end

  def format(result)
    include_output_style

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

    if SimpleCov::Formatter::Console.sort == 'coverage'
      files = result.files.sort{ |a,b| a.covered_percent <=> b.covered_percent }
    else
      files = result.files
    end

    covered_files = 0

    unless SimpleCov::Formatter::Console.show_covered
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
    end

    max_rows = SimpleCov::Formatter::Console.max_rows

    if ![-1, nil].include?(max_rows) && files.size > max_rows then
      puts "showing bottom (worst) #{max_rows} of #{files.size} files"
      files = files.slice(0, max_rows)
    end

    puts output(files,root)

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
