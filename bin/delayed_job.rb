#!/usr/bin/env ruby
require 'delayed/command'
Delayed::Command.new(ARGV).daemonize
