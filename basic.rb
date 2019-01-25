require 'mechanize'

first_arg, *the_rest = ARGV

mechanize = Mechanize.new

mechanize.robots = true
mechanize.redirection_limit = 5
mechanize.open_timeout = 10
mechanize.read_timeout = 10

page = mechanize.get('http://' + first_arg)

links = page.links

while link = links.shift
  begin
    uri = mechanize.resolve(link.uri)

    p uri.host

    next unless (uri.host =~ /first_arg.to_s/).nil?

    #next if mechanize.visited?(link)

    page = mechanize.click(link)

    puts page.title

    links.concat(page.links)
  rescue Mechanize::UnsupportedSchemeError
  rescue Mechanize::RobotsDisallowedError
  rescue Mechanize::RedirectLimitReachedError
  rescue Mechanize::ResponseCodeError => exception
    if exception.response_code == '404'
      puts "broken link from #{link.page.uri} to #{link.uri}"
    else
      # ignore other errors
    end
  end
end
