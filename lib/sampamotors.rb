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
        },
        {
          email_id: 'website',
          name: 'Website - Novos'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      destinatary = @email.to.map { |email| email[:email].split('@').first } 

      if destinatary.include?('jivochat')
        parse_jivochat
      elsif destinatary.include?('website')
        parse_website
      end
    end

    private 

    def parse_website
      parsed_email = @email.body.colons_to_hash
      message = parsed_email['mensagem'].gsub("\n", ' ').gsub('--','')
      store = parsed_email['loja']
      message += " Unidade: #{store}" if store

      {
        source: {
          name: F1SalesCustom::Email::Source.all[1][:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: parsed_email['produto'],
        message: message,
        description: parsed_email['origem']
      }
    end

    def parse_jivochat
      parsed_email = @email.body.colons_to_hash(/(nome|email|telefone|produto|mensagem).*?:/, false)

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
        message: parsed_email['mensagem'],
      }
    end
  end  
end
