class Logo < ApplicationRecord
	has_one_attached :image
	def user_params
    	params.require(:logo).permit(:company)
	end
end
