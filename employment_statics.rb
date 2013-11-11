require 'nokogiri'
require 'open-uri'
require 'data_mapper'


DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/empInfo.db")

class EmpInfo
  include DataMapper::Resource
  property :id, Serial
  property :infoId, String, :unique => true
  property :city, String, :required => true
  property :job, String, :required => true
  property :tag, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

def searchCityWithTitle(noteTitle)
  puts Dir.pwd
  File.open("#{Dir.pwd}/cityList.txt", "r").each_line do |line|
    puts line
  end
end


def getTagsFromTitle(title)
  f = File.open("#{Dir.pwd}/jobCategory.txt", "r")
  jobs = []
  f.each_line do |line|
    jobs << line.chomp if title.downcase.include? line.chomp.downcase
  end
  puts " in tag #{jobs.join ','}"
  jobs.join ","
end



def getCityNamesOfTitle(title)
  f1 = File.open("#{Dir.pwd}/newMainCities.txt", "r")
  cityNames = []
  f1.each_line do |line|
     cityNames << line.chomp if title.include? line.chomp
  end
   puts " in city #{cityNames.join ','}"
   cityNames.join ","

end



def searchTitle(pageNo)
  # puts "http://www.v2ex.com/go/jobs?p=#{pageNo}"
  doc = Nokogiri::HTML(open("http://www.v2ex.com/go/jobs?p=#{pageNo}"))

  # doc.xpath("//span[@class='item_title']").each do |line|
#     puts line
#   end

 doc.css('span.item_title').each do |line|

   puts "#{line.text}"
   emp = EmpInfo.new
   emp.infoId = line.css('a')[0]["href"].gsub(/\/t\//,'')
   emp.job = line.text
   emp.tag = getTagsFromTitle(emp.job)
   emp.city = getCityNamesOfTitle(emp.job)

   emp.created_at = Time.now
   emp.updated_at = Time.now
   # puts emp
   emp.save

 end

end


# def handleCityName
#   f1 = File.open("#{Dir.pwd}/newMainCities.txt", "w")
#
#   File.open("#{Dir.pwd}/mainCities.txt", "r").each_line do |line|
#     substrings = line.split;
#     f1.write("#{substrings[0]}\n")
#
#   end
# end

# handleCityName


# searchTitle(2)

(1..20).each do |page|
  searchTitle(page)
  sleep(5)
end







# puts "[杭州]找iOS,Android开发小伙伴,UI设计师".downcase.include? "android".downcase





