require "json"
require "Date"
module App
    def data
        data = JSON.parse(File.read('data.json'))
    end

    def practitioners
        data['practitioners'].map {|e| Practitioner.new(e)}
    end

    def communications
        data['communications'].map {|e| Communication.new(e)}
    end

    def find(n)
        practitioners.find {|p| p.id == n}
    end

    def daily_price
        daily_price = Hash.new(0)
        communications.each {|c| daily_price[c.sent_at.to_date] += c.price}
        daily_price
    end

    def output
        JSON.pretty_generate("totals" => daily_price.map {|k, v| {"sent_on" => k, "total" => v}})
    end

    def write
        File.open("output.json", "w") {|file| file.write(output)}
    end
    
end

class Practitioner
    extend App
    attr_reader :id, :express_delivery
    def initialize(args)
        @id = args['id']
        @first_name = args['first_name']
        @last_name = args['last_name']
        @express_delivery = args['express_delivery']
    end
end

class Communication
    attr_reader :practitioner_id, :pages_number, :color, :sent_at
    def initialize(args)
        @id = args['id']
        @practitioner_id = args['practitioner_id']
        @pages_number = args['pages_number']
        @color = args['color']
        @sent_at = Date.parse(args['sent_at'])
    end

    def price
        base_price + color_mode_price + additional_page_price + express_delivery_price
    end

    def base_price
        0.10
    end

    def color_mode_price
        color ? 0.18 : 0
    end

    def additional_page_price
        0.07 * (pages_number - 1)
    end

    def express_delivery_price
        Practitioner.find(practitioner_id).express_delivery ? 0.60 : 0 
    end

end


Practitioner.write