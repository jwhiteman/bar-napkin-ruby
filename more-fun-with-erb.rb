template = ERB.new <<-EOF
text
<% shout do |m| %>
  ZXYPQ! <%= m %> !QPYXZ
<% end %>
EOF

puts template.result

def shout(&block)
  yield eval('_erbout', block.binding)
end


# VERY instructive:

template = ERB.new(<<-EOF, 0, '<>')
text
<% shout do %>
quux!
<% end %>
EOF

template.src =>

# returns the following wrapped in a string to be eval'd with whatever binding you provide.
_erbout = ''
_erbout.concat("text\n")
shout do # this is a closure, so the _erbout above is added to the block's binding
 _erbout.concat("quux!\n")
end 
_erbout  # it's all about this variable. you either concat to it, or your shit doesn't get rendered, cuz it's the only thing being returned


# testing <%= ... %>

template = ERB.new(<<-EOF, 0, '<>')
text
<%= 1 + 2 + 3 %>
<%= 'hi'.upcase %>
EOF

template.src =>

_erbout = ''
_erbout.concat "text\n"
_erbout.concat(( 1 + 2 + 3 ).to_s)      # notice, not eval'd yet, otherwise it would look like:  _erbout.concat((6).to_s)
_erbout.concat(( 'hi'.upcase ).to_s)    # notice, not eval'd yet, otherwise it would look like:  _erbout.concat('HI').to_s)
_erbout


# Even more unstructive...
template = ERB.new(<<-EOF, 0, '<>')
text
<% shout do %>
  a: <%= 1 + 1 %>
  b: <%= 2 + 2 %>
  c: <%= Time.now %>
<% end %>
EOF

_erbout = ''; 
_erbout.concat "text\n"
shout do 
  _erbout.concat "  a: "; _erbout.concat(( 1 + 1 ).to_s); _erbout.concat "\n"
  _erbout.concat "  b: "; _erbout.concat(( 2 + 2 ).to_s); _erbout.concat "\n"
  _erbout.concat "  c: "; _erbout.concat(( Time.now ).to_s); _erbout.concat "\n"
end 
_erbout