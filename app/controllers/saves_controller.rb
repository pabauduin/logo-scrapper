require 'open-uri'
require 'httparty'

class SavesController < ApplicationController
	def index
	end

	def generating
		@logos = Logo.all
	    accents = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
	      ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
	      ['í','ì','î','ï','I','Î','Ì'] => 'i',
	      ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
	      ['œ'] => 'oe',
	      ['ß'] => 'ss',
	      ['ú','ù','û','ü','U','Û','Ù'] => 'u',
	      ['ç','Ç'] => 'c'
	    }
	    @logos.each { |logo|
	    	accents.each do |ac,rep|
		    	ac.each do |s|
		    		logo.company.gsub!(s, rep)
        		end
		    end
			if !logo.company.nil?
		        if logo.company.include?(" ")
		          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&'/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("’","").gsub("(","-").gsub(")","-").gsub(/\s+/, '')
		        else
		          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("(","-").gsub(")","-").gsub("’","")
		        end
		        if @logos.where(name: gsub_logo.downcase).count <= 0
		        	logo.name = gsub_logo.downcase
		        	logo.save
		        end
		        puts "---"
		        puts "---"
		        puts logo.name
		        if !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") && 
		          url = "https://logo.clearbit.com/#{gsub_logo}.com"
		          puts url
		          puts "----"
		          puts "----"
		          url.reverse.split('/', 3).collect(&:reverse).reverse[2]
		          logo.image.attach(io: URI.open(url)  , filename: "#{gsub_logo.downcase}.png")
		        end
		        if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") 
			        if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
			        	logo.delete
			        elsif !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
			        	url = "https://logo.clearbit.com/#{gsub_logo}.fr"
						puts url
						puts "----"
						puts "----"
						url.reverse.split('/', 3).collect(&:reverse).reverse[2]
						logo.image.attach(io: URI.open(url)  , filename: "#{gsub_logo.downcase}.png")

			        end
		        end
	    	else
	    		logo.delete
	    	end
	    }
	    @logos.where(name: nil).delete_all
	    redirect_to '/logos'
	end
end