atom_feed do |feed|
  feed.title("restbuy search engine")

  feed.updated(Time.now)

  @products.each do |product|
    feed.entry(product) do |entry|

      entry.title(h(product.name))
      entry.link(:rel=>"self", :href => product_path(product), :type => "application/xml")

      entry.author do |author|
        author.name(product.name)
      end
    end
  end
end
