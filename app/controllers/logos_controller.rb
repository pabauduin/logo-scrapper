class LogosController < ApplicationController

  def index
    @logos = Logo.all.sort_by(&:updated_at).reverse
  end

  def delete_all
    if Logo.delete_all
      puts "logos deleted"
      redirect_to '/logos', :notice => "Your logo has been deleted"
    else 
      puts "not destroyed"
    end
  end

  def saving
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
      if logo.company.include?(" ")
        gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&'/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("’","").gsub("(","-").gsub(")","-").gsub(/\s+/, '')
      else
        gsub_logo = logo.company.gsub("[^[:alnum:][:blank:]+?&/\\-]", "").gsub("/","").gsub("\\","").gsub("'","").gsub("&","-").gsub(".","-").gsub("(","-").gsub(")","-").gsub("’","")
      end
      puts "https://logo.clearbit.com/#{gsub_logo}.com"
      puts "---"
      puts "---"
      if !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.com").response.to_s.include?("NotFound")
        IO.copy_stream(URI.open("https://logo.clearbit.com/#{gsub_logo}.com"), "app/assets/images/#{logo.name}.png")
      elsif !HTTParty.get("https://logo.clearbit.com/#{gsub_logo}.fr").response.to_s.include?("NotFound")
        IO.copy_stream(URI.open("https://logo.clearbit.com/#{gsub_logo}.fr"), "app/assets/images/#{logo.name}.png")
      end
    }
  end

  def show
    @logo = Logo.find(params[:id])
  end

  def download
    @logo = Logo.find(params[:id])
    @logo.image.download
    redirect_to logos_path
  end

  def new
    @logo = Logo.new
  end

  def create_companies
    logos_companies = params[:companies].split(/,\s*/)
    # companies = Logo.where(company: logos_companies)

    logos_companies.each do |company|
      Logo.create!(company: company)
    end
    redirect_to new_logo_path
  end

  def create
    @logos = Logo.all
    @logo = Logo.new(logo_params)
    puts params[:logo][:company] == "swag"
    puts "---"
    if @logos.where(company: params[:logo][:company]).count > 0
      redirect_to new_logo_path
    else 
      if @logo.save
        puts "logo created"
        redirect_to new_logo_path
      else
        puts "logo not created"
        redirect_to new_logo_path
      end
    end
  end

  def destroy
    @logo = Logo.find(params[:id])
    if @logo.destroy
      puts "logo destroyed"
      redirect_to '/logos', :notice => "Your logo has been deleted"
    else 
      puts "not destroyed"
    end
  end

  private
    def logo_params
      params.require(:logo).permit(:company)
    end

end