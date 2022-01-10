require 'cloudinary'
class LogosController < ApplicationController

  def index
    @logos = Logo.all.sort_by(&:updated_at).reverse
  end

  def new
    @logo = Logo.new
  end

  def generate_logos
    logos_companies = params[:companies].split(/,\s*/)
    logos = Logo.all
    if logos.count > 0
      logos.each { |logo|
        Cloudinary::Uploader.destroy("Logos/#{logo.name}")
        puts "logo destroyed"
        logo.destroy
      }
    end
    logos_companies.each { |company|
      Logo.create!(company: company)
    }
    generate
    redirect_to logos_path

    ## Getting all accents
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

      ## Removing accents
      accents.each do |ac,rep|
        ac.each do |s|
          logo.company.gsub!(s, rep)
          end
      end

      if !logo.company.nil?
        ## Gsubing logo with spaces
        if logo.company.include?(" ")
          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&'/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("’","").gsub("(","-").gsub(")","-").gsub(/\s+/, '')
        ## Gsubing logo without spaces
        else
          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("(","-").gsub(")","-").gsub("’","")
        end

        ## Saving logos
        if @logos.where(name: gsub_logo.downcase).count <= 0
          logo.name = gsub_logo.downcase
          logo.save
        end

        ## Upload to cloudinary
        if !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") && 
          url = "https://logo.clearbit.com/#{gsub_logo}.com"
          url.reverse.split('/', 3).collect(&:reverse).reverse[2]
          Cloudinary::Uploader.upload(url, :folder => "Logos",
          public_id: gsub_logo, asset_id: gsub_logo, use_filename: true,  unique_filename: false)  
        end

        ## If logo.com not found, check in FR and then delete logo
        if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") 
          if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
            logo.delete
          elsif !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
            url = "https://logo.clearbit.com/#{gsub_logo}.fr"
            url.reverse.split('/', 3).collect(&:reverse).reverse[2]
            Cloudinary::Uploader.upload(url, :folder => "Logos",
            public_id: gsub_logo, asset_id: gsub_logo, use_filename: true,  unique_filename: false)
          end
        end
      else
        ## If logo nil, delete logo
        logo.delete
      end
    }
    @logos.where(name: nil).delete_all
  end

  def destroy
    @logo = Logo.find(params[:id])
    Cloudinary::Uploader.destroy("Logos/#{@logo.name}")
    if @logo.destroy
      puts "logo destroyed"
      redirect_to '/logos', :notice => "Your logo has been deleted"
    else 
      puts "not destroyed"
    end
  end

  def destroy_all
    Logo.all.each { |logo|
      Cloudinary::Uploader.destroy("Logos/#{logo.name}")
      puts "logo destroyed"
    }
    if Logo.destroy_all 
      puts "logos deleted"
      redirect_to '/logos', :notice => "Your logo has been deleted"
    else 
      puts "not destroyed"
    end
  end

  def generate
    @logos = Logo.all

    ## Getting all accents
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

      ## Removing accents
      accents.each do |ac,rep|
        ac.each do |s|
          logo.company.gsub!(s, rep)
          end
      end

      if !logo.company.nil?
        ## Gsubing logo with spaces
        if logo.company.include?(" ")
          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&'/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("’","").gsub("(","-").gsub(")","-").gsub(/\s+/, '')
        ## Gsubing logo without spaces
        else
          gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("(","-").gsub(")","-").gsub("’","")
        end

        ## Saving logos
        if @logos.where(name: gsub_logo.downcase).count <= 0
          logo.name = gsub_logo.downcase
          logo.save
        end

        ## Upload to cloudinary
        if !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") && 
          url = "https://logo.clearbit.com/#{gsub_logo}.com"
          url.reverse.split('/', 3).collect(&:reverse).reverse[2]
          Cloudinary::Uploader.upload(url, :folder => "Logos",
          public_id: gsub_logo, asset_id: gsub_logo, use_filename: true,  unique_filename: false)  
        end

        ## If logo.com not found, check in FR and then delete logo
        if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound") 
          if HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
            logo.delete
          elsif !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound") 
            url = "https://logo.clearbit.com/#{gsub_logo}.fr"
            url.reverse.split('/', 3).collect(&:reverse).reverse[2]
            Cloudinary::Uploader.upload(url, :folder => "Logos",
            public_id: gsub_logo, asset_id: gsub_logo, use_filename: true,  unique_filename: false)
          end
        end
      else
        ## If logo nil, delete logo
        logo.delete
      end
    }
    @logos.where(name: nil).delete_all
  end

  private
  def logo_params
    params.require(:logo).permit(:company)
  end
end