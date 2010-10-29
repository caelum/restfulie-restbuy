require 'respondie'

module Restfulie::Server::ActionController::Trait::Created
  def to_format
    if (options[:status] == 201) || (options[:status] == :created)
      render :status => 201, :location => controller.url_for(resource), :text => ""
    else
      super
    end
  end
end
