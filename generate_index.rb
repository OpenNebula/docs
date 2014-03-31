#!/usr/bin/env ruby

require "pp"
require "erb"

def path_to_url(path)
    path.gsub(%r{^source/},"").
         gsub(%r{\.rst},".html")
end

def get_toc(file)
    guides = []

    File.read(file).scan(/^\s*(.*?)\s*<(.*)>$/).each do |name, relative_path|
        next if name =~ /release notes/i

        path = File.join(File.dirname(file), relative_path + ".rst")
        guide = {
            :name => name,
            :path => path,
            :url  => path_to_url(path)
        }

        if relative_path.include?("/")
            guide[:children] = get_toc(path)
        end

        guides << guide
    end

    guides
end

toc = get_toc('source/index.rst')

nrow = -1
toc_template = %q{
    <h3><a href="<%= manual[:url] %>"><%= manual[:name] %></a></h3>
    <div class="ofp-boxes">
        <% manual[:children].each do |box| %>
            <% nbox = nboxes.next %>
            <% nrow += 1 if nbox == 1 %>
            <div class="ofp-box ofp-box-<%= nbox %> ofp-box-row-<%= nrow %>">
                <a href="<%= box[:url] %>">
                    <%= box[:name] %>
                </a>
                <ul>
                    <% box[:children].each do |guide| %>
                        <li>
                            <a href="<%= guide[:url] %>">
                                <%= guide[:name]%>
                            </a>
                        </li>
                    <% end %>
                </ul>
            </div><!-- close ofp-box -->
        <% end %>
    </div><!-- close ofb-boxes -->
}

puts %q{<div id="opennebula-frontpage">}
toc.each do |manual|
    nboxes = (1..3).cycle
    # styles = ['ofp-box-1','ofp-box-2','ofp-box-3'].cycle
    puts ERB.new(toc_template).result(binding)
end
puts %q{</div><!-- close opennebula-frontpage -->}
