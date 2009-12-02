#!/usr/bin/env ruby

require 'open-uri'
require "rss/1.0"
require "rss/2.0"
require "rss/dublincore"

require "rubygems"
require "hatenabm"

# replace your account / password
HATENA_USER = "Hash"         # はてなブックマークのユーザ名
HATENA_PASS = ""         # はてなブックマークのパスワード
DELICIOUS_USER = "TakuyaHashimoto" # del.icio.us のユーザ名

def get_content(url)
	open(url) {|f| content = f.read }
end

def parse_rss(content)
	begin
		RSS::Parser.parse(content)
	rescue RSS::InvalidRSSError
		RSS::Parser.parse(content, false)
	end
end

begin
	url = "http://b.hatena.ne.jp/#{HATENA_USER}/rss"
	content = get_content(url)
	last_update = parse_rss(content).items[0].dc_date.getlocal

	url = "http://del.icio.us/rss/#{DELICIOUS_USER}"
	content = get_content(url)
	rss = parse_rss(content)

	i = 0
	rss.items.each do |item|
		break if item.dc_date.getlocal < last_update
		i += 1
	end

	if i.zero?
		exit
	else
		i -= 1
	end

	hbm = HatenaBM.new(
	:user => HATENA_USER,
	:pass => HATENA_PASS
	)

	i.downto(0) do |j|
		begin
			item = rss.items[j]
			hbm.post(
			:title   => item.title ? item.title : "",
			:link    => item.link ? item.link : "",
			:summary => item.description ? item.description : "",
			:tags    => item.dc_subject ? item.dc_subject : ""
			)
		rescue
			next
		end
		sleep(1)
	end
end
