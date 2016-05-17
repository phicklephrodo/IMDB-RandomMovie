require 'open-uri'

fn = ARGV[0]
ln = ARGV[1]
url = "http://www.imdb.com/search/name?name=#{fn}%20#{ln}"
page_source = open(url, &:read)
name_index = page_source.index('<td class="name">')
if !name_index then 
	puts "Can't find that shit"
	abort
end
substring = page_source[name_index..(name_index+50)]
name_url = substring[31..46]

url = "http://www.imdb.com#{name_url}"
page_source = open(url, &:read)
table_index = page_source.index('filmo-category-section')
end_index = page_source.index('filmo-head-producer')
page_source = page_source[table_index..end_index]

movies = []
itr = true
while itr do 
	cur_index = page_source.index('/title/')
	if cur_index then
		working_area = page_source[cur_index..cur_index+100]
		open_index = working_area.index('>')
		close_index = working_area.index('<')
		if open_index && close_index then
			movies << working_area[open_index+1..close_index-1]
		end
		page_source = page_source[cur_index+100..-1]
	else
		itr = false
	end
end

puts movies.sample