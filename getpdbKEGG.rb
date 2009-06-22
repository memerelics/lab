#!/usr/bin/ruby

require 'rubygems'
require 'bio'
api = Bio::KEGG::API.new

pdbtxt = api.bget('pdb: + #{ARGV[0]}')
puts pdbtxt
