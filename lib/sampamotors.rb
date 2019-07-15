require "sampamotors/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Sampamotors
  class Error < StandardError; end

  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'jivochat',
          name: 'JivoChat'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(nome|email|telefone|produto).*?:/, false)

      {
        source: {
          name: F1SalesCustom::Email::Source.all.first[:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: parsed_email['produto'],
        message: '',
      }

    end
  end  
end
