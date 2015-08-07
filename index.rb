require "sinatra"
require 'haml'

set :views, "views"

get '/' do
	haml :index, :locals => {'percent' => " "}	
end

post '/' do
 
	percent = params[:percent]
	sum = params[:sum]
	period = params[:period]
	stand = params[:method]
	tr = params[:method] <=> "standard"
	
	unless percent.nil? || sum.nil? || period.nil? 
		if((params[:method] <=> "standard") == 0)
			calc = Calculator.new(percent, sum, period)
			calc.calc
			
			i = 0
			temp = " "

			while i < period.to_i do
				temp = temp + "   |  " + calc.get1[i].to_s
				temp = temp + "   |  " + calc.get2[i].to_s
				temp = temp + "   |  " + calc.get3[i].to_i.to_s
				temp = temp + "   |  " + calc.get4[i].to_i.to_s
				temp = temp + "   |  " + calc.get5[i].to_s
				temp = temp + "<br>" 
				i = i + 1
			end
			haml :index, :locals => {'percent' => temp}	
		elsif ((params[:method] <=> "equal") == 0)
			calc = Calculator.new(percent, sum, period)
			calc.calc2
			
			i = 0
			temp = " "

			while i < period.to_i do
				temp = temp + "   |  " + calc.get1[i].to_s
				temp = temp + "   |  " + calc.get2[i].to_s
				temp = temp + "   |  " + calc.get3[i].to_i.to_s
				temp = temp + "   |  " + calc.get4[i].to_i.to_s
				temp = temp + "   |  " + calc.get5[i].to_s
				temp = temp + "<br>" 
				i = i + 1
			end
			haml :index, :locals => {'percent' => temp}	
		else 
			temp = " "
			haml :index, :locals => {'percent' => temp}	
		end
	else 
		temp = " "
		haml :index, :locals => {'percent' => temp}	
	end
end

class Calculator
	
	def initialize (percent, sum, period)
		@percent = percent.to_f
		@sum = sum.to_i
		@period = period.to_i
	end
	
	def pay_off
		pay_credit = @sum /@period 
		return pay_credit
	end
	
	def calc	
		size = @period
		@months = Array.new(size)
		@pay_cr = Array.new(size)
		@per_month = Array.new(size)
		@sum_month = Array.new(size)
		@rest_of_credit = Array.new(size)
		sum = @sum
		i = 0
		while i < @period do
			@months[i] = i +1
			@pay_cr[i] = pay_off
			@per_month[i] = (sum * (@percent/100) )/ 12
			@sum_month[i] = pay_off + (sum * (@percent/100) / 12)
			@rest_of_credit[i] = sum - pay_off
			sum = sum - pay_off
			i = i + 1
		end

	end
	
	def calc2
		ps = @percent / 12 /100
		platez = @sum *(ps + (ps / ((1 + ps) ** @period - 1)))
		
		size = @period
		@months = Array.new(size)
		@pay_cr = Array.new(size)
		@per_month = Array.new(size)
		@sum_month = Array.new(size)
		@rest_of_credit = Array.new(size)
		
		sum = @sum
		i = 0
		while i < @period do
			@months[i] = i +1
			@pay_cr[i] = platez - (sum * (@percent/100) )/ 12
			@per_month[i] = (sum * (@percent/100) )/ 12
			@sum_month[i] = platez
			@rest_of_credit[i] = sum - (platez - (sum * (@percent/100) )/ 12)
			sum = sum - (platez - (sum * (@percent/100) )/ 12)
			i = i + 1
		end
	end
	
	def get1 
		return @months
	end
	
	def get2
		return @pay_cr
	end
	
	def get3
		return @per_month
	end
	
	def get4
		return @sum_month
	end
	
	def get5
		return @rest_of_credit
	end
	
end
