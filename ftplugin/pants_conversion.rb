#!/usr/bin/env ruby
# frozen_string_literal: true

class LastCompileError
  def initialize(file, line, message)
    @file = file
    @line = line
    @message = message
  end

  def add(input)
    if /^(?<spaces>\s+)\^/ =~ input
      @column = spaces.size - 22
      return
    end

    if @column
      @message << " #{input.strip}"
      return true
    end

    nil
  end

  def to_s
    "#{@file}:#{@line}:#{@column}: #{@message}"
  end
end

class LastTestFailure
  def initialize(root, package, meth)
    @root = root
    @package = package
    @meth = meth
    @file_regex = /#{package.match(/\.(\w+)$/)[1]}.java:(\d+)/
    @message = nil
    @line = nil
  end

  def add(input)
    unless @message
      @message = input.strip
      return
    end

    if (match = @file_regex.match(input))
      @line = match[1]
      return true
    end

    nil
  end

  def to_s
    "#{@root}/src/test/java/#{@package.tr('.', '/')}.java:#{@line}: #{@meth}: #{@message}"
  end
end

relative_root = ARGV[1]
last_compile_error = nil
last_test_failure = nil

while (input = STDIN.gets)
  next if /^\d+:\d+:\d+ \d+:\d+\s+\[.+\](\s|\.)*$/ =~ input

  puts input
  STDOUT.flush

  if last_compile_error
    if last_compile_error.add(input)
      puts last_compile_error
      last_compile_error = nil
    end
    next
  end

  if last_test_failure
    if last_test_failure.add(input)
      puts last_test_failure
      last_test_failure = nil
    end
    next
  end

  if /(?:Compiling \d+ java sources in \d+ target \(\S+\)\.)?(?<file>\S+):(?<line>\d+): error: (?<message>.+)/ =~ input
    last_compile_error = LastCompileError.new(file, line, message)
    next
  end

  if /\d+\) (?<meth>\w+)\((?<package>.+)\)/ =~ input
    last_test_failure = LastTestFailure.new(relative_root, package, meth)
    next
  end
end

raise "#{__FILE__}: parsing error!" if last_test_failure || last_compile_error
