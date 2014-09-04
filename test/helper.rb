require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require "simplecov"
require "minitest/autorun"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simplecov-console'

class MiniTest::Test
end

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start do
  add_filter "/test/"
end

MiniTest.autorun
