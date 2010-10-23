require 'spec_helper'

class Object
  def debug
    debugger
    self
  end
end

describe Restfulie do
  
  context "when searching" do
    
    it "should be able to search items" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.debug.resource
      items = description.accepts("application/atom+xml").search(:searchTerms => "apple", :startPage => 1)
      items.resource.size.should == 2
    end
    
  end

end