require "option_parser"
require "./util"
require "./parser"

# TODO: Write documentation for `Comma`
module Comma
  VERSION = "0.1.0"

  # TODO: Put your code here
  puts "its ,lang baby. hell yeah"
  files = [] of String
  cpp_destination = Path.new(Dir.tempdir, "comma.cpp").to_s
  output = [] of String

  OptionParser.parse do |parser|
    parser.banner = ",lang"

    parser.on "-v", "--version", "Show version" do
      puts "version #{VERSION}"
      exit
    end
    parser.on "-h", "--help", "Show help" do
      puts parser
      exit
    end
    parser.on "-o", "--output FILE", "Output to file" do |file|
      output << file
    end
    parser.on "--cpp FILE", "Output C++ to this file instead of tmp (#{cpp_destination})" do |file|
      cpp_destination = file
    end
    parser.unknown_args do |args|
      files = args
    end
  end

  if files.empty?
    puts "no files specified"
    exit
  end

  if output.size != files.size
    puts "output files not specified for all input files"
    exit
  end

  files.each.zip(output.each) do |file, output|
    puts "file: #{file}"
    parser = Parser.new Lexer.new Reader.from_file file
    program = parser.parse
    debu! program
    cpp = program.cppify
    debu! cpp
    File.write(cpp_destination, cpp)
    puts "wrote to #{cpp_destination}"
    puts "compiling..."
    puts "$ clang++ #{cpp_destination} -o #{output}"
    process = Process.new "clang++", args: [cpp_destination, "-o", output], output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    status = process.wait
    puts "Status: #{status}"
    # File.delete tempfile
    if !status.success?
      puts "compilation failed"
      exit status.exit_code
    end
    puts "compiled :3"
  end
end
