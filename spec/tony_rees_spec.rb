#!/usr/bin/env ruby1.9
# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + "/../lib/tony_rees")

describe 'tony rees algorithm' do
  mdld("Protozoa", "Pratozoa").should == 1
  mdld("Protozoa", "Partozoa", 1).should == 2
end
