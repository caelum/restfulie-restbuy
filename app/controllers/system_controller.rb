module Searchie
  class OpenSearch
    def types
      @types ||= {}
    end
    def accepts(type)
      OpenSearchMediaType.new(type, self)
    end
    
    def register(t, uri)
      types[t] = uri
    end
    
    def to_xml
      '<?xml version="1.0" encoding="UTF-8"?>
      <OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
        <ShortName>Restbuy</ShortName>
        <Description>Restbuy search engine.</Description>
        <Tags>restbuy</Tags>
        <Contact>admin@restbuy.com</Contact>' +
        uris +
      '</OpenSearchDescription>'
    end
    def uris
      uris = ""
      types.each do |key, value|
        uris = uris + "<Url type=\"#{key}\"  template=\"#{value}\" />"
      end
      uris
    end
  end
  
  class OpenSearchMediaType
    def initialize(type, search)
      @type = type
      @search = search
    end
    def at(uri)
      @search.register(@type, uri)
      @search
    end
  end
end

class SystemController < ApplicationController
  
  def logout
    session[:order] = nil
    redirect_to :controller => :products, :action=> :index
  end
  
  def search
    render :content_type => "application/opensearchdescription+xml", :text => Searchie::OpenSearch.new.accepts("application/atom+xml").at(products_url + "?q={searchTerms}&amp;pw={startPage?}&amp;format=atom").to_xml
  end
  
end
