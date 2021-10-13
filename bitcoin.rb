require 'rest-client'
require 'json'
require 'terminal-table'

days_to_show = ARGV[0] ? ARGV[0].split("=")[1].to_i : 7

end_date = Date.today.strftime("%Y-%m-%d") 
start_date = (Date.today - days_to_show).strftime("%Y-%m-%d")

url = 'https://api.coindesk.com/v1/bpi/historical/close.json'

params = "?start=#{start_date}&end=#{end_date}"

response = RestClient.get "#{url}#{params}", {
  content_type: :json,
  accept: :json 
}

bpi = JSON.parse(response.body)["bpi"]
bpi_keys = bpi.keys

table_data = bpi.map.with_index do |(date, value), i|
    [
        Date.parse(date).strftime("%y-%m-%d"),
        "$#{value.to_f}",
        (i > 0 ? (bpi[bpi_keys[i]] > bpi[bpi_keys[i - 1]] ? "↑" : "↓") : "")
    ]
end

table = Terminal::Table.new headings: ["Data", "Valor do bitcoin", "B"], :rows => table_data

puts table