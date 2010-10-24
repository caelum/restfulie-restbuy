atom_feed do |feed|
  feed.title("restbuy search engine")

  feed.updated(Time.now)
  feed.link(:rel=>"order", :href => orders_url, :type => "application/xml")

  @products.each do |product|
    feed.entry(product) do |entry|

      entry.title(h(product.name))
      entry.link(:rel=>"self", :href => product_url(product), :type => "application/xml")

      entry.author do |author|
        author.name(product.name)
      end
    end
  end
end
