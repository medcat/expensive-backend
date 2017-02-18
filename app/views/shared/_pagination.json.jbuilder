current_page = group.current_page
total_pages = group.total_pages
next_page = current_page + 1 > total_pages ? current_page : current_page + 1
prev_page = current_page - 1 < 1 ? current_page : current_page - 1

json.meta do
  json.pages do
    json.current current_page
    json.total total_pages

    json.links((1..total_pages).map do |i|
      url_for(page: i)
    end)
  end

  json.links do
    json.next url_for(page: next_page)
    json.prev url_for(page: prev_page)
    json.self url_for
    json.none url_for(page: nil)
  end
end

