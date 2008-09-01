#!/usr/bin/env ruby ../../bin/rackup
#\ -E deployment -I ~/projects/rack/lib
# -*- ruby -*-

require '../testrequest'

run TestRequest.new
