#! /usr/bin/env ruby

# encoding: utf-8

require 'csv'
require 'digest'
require 'nokogiri'
require 'open-uri'
require 'json'

URL = 'https://www.fio.cz/ib2/transparent?a=2501277007&f=01.08.2017&t=01.08.2018'.freeze
FIELDS = %w(datum castka typ protiucet zprava ks vs ss poznamka).freeze

def main
  page = Nokogiri::HTML(open(URL))

  data = page.css('div.content > table > tbody > tr').map do |element|
    res = {}

    FIELDS.each_with_index do |name, idx|
      res[name] = element.css("td[#{idx + 1}]").text.strip
    end
    castka = res['castka']
    parts = castka.split("\u00A0")
    res['datum'] = Date.strptime(res['datum'], '%d.%m.%Y').iso8601
    res['mnozstvi'] = parts[0].tr(',', '.').to_f
    res['mena'] = parts[1]
    res['id'] = Digest::SHA256.hexdigest(JSON.pretty_generate(res))
    res
  end

  json = JSON.pretty_generate(data)
  puts json

  File.open('data/data.json','w') do |f|
    f.write(json)
  end

  CSV.open('data/data.csv', 'wb') do |csv|
    csv << data.first.keys # adds the attributes name on the first line
    data.each do |hash|
      puts hash.inspect
      csv << hash.values
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end
