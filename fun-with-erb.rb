require 'erb'

class CompiledPage
  attr_accessor :layout, :partial, :title, :message
  
  def initialize(title, message)
    @title = title
    @message = message
  end
  
  def build
    b = binding
    ERB.new(<<-END_OF_BODY.gsub(/^\s+/, ""), 0, '', '@body').result(b)
      <h1><%= @message %></h1>
    END_OF_BODY
    ERB.new(<<-END_OF_LAYOUT.gsub(/^\s+/, ""), 0, '' '@layout').result(b)
      <html>
        <head>
          <title><%= @title %></title>
        </head>
        <body>
          <%= @body %>
        </body>
      </html>
    END_OF_LAYOUT
  end
end

c = CompiledPage.new('A Cool Template', 'hello, world')
puts c.build
          