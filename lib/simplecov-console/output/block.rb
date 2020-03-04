
class SimpleCov::Formatter::Console
  module BlockOutput

    # format per-file results output as plain text blocks
    def output(files, root)
      blocks = []
      files.each do |f|
        block = []
        block << sprintf("%8.8s: %s", 'file', f.filename.gsub(root + "/", ''))
        block << sprintf("%8.8s: %s (%d/%d lines)", 'coverage',
                    colorize(sprintf("%.2f%%", f.covered_percent)),
                    f.covered_lines.count, f.lines_of_code)
        block << sprintf("%8.8s: %s", 'missed', missed(f.missed_lines).join(", "))
        blocks << block.join("\n")
      end

      "\n" + blocks.join("\n\n") + "\n\n"
    end

  end
end
