require 'terminal-table'

class SimpleCov::Formatter::Console
  module TableOutput

    # format per-file results output using Terminal::Table
    def output(files, root)
      table = files.map do |f|
        [
          colorize(pct(f)),
          f.filename.gsub(root + "/", ''),
          f.lines_of_code,
          f.missed_lines.count,
          missed(f.missed_lines).join(", ")
        ]
      end

      table_options = SimpleCov::Formatter::Console.table_options || {}
      if !table_options.kind_of?(Hash) then
        raise ArgumentError.new("SimpleCov::Formatter::Console.table_options must be a Hash")
      end

      headings = %w{ coverage file lines missed missing }

      opts = table_options.merge({:headings => headings, :rows => table})
      Terminal::Table.new(opts)
    end

  end
end
