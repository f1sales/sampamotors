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
        {
          email_id: 'website',
          name: 'Website - Serviços e Peças'
        },
        {
          email_id: 'jivochat',
          name: 'JivoChat - Seminovos'
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

    WANTS_TO_SELL = 'solicitação de venda'

    def parse_website
      all_sources = F1SalesCustom::Email::Source.all
      is_about_sell = @email.subject.downcase.include?(WANTS_TO_SELL)


      parsed_email = @email.body.colons_to_hash
      parsed_email = @email.body.colons_to_hash(/(Nome|Cambio|Ano|Portas|Quilometragem|Marca\/Modelo|E-mail|Email|Tipo|Telefone|produto|mensagem).*?:/, false) if is_about_sell


      message = (parsed_email['mensagem'] || '').gsub("\n", ' ').gsub('--','')
      store = parsed_email['loja']
      message += " Unidade: #{store}" if store
      source = is_about_sell ? all_sources[2] : all_sources[1]
      product = parsed_email['produto'] || parsed_email['marcamodelo']

      message += "Portas: #{parsed_email['portas']} Quilometragem: #{parsed_email['quilometragem']} Ano: #{parsed_email['ano']} Cambio: #{parsed_email['cambio']}" if is_about_sell
      description = parsed_email['origem'] || ''
      description += " #{WANTS_TO_SELL}" if is_about_sell

      {
        source: {
          name: source[:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: product || '',
        message: message,
        description: description,
      }
    end

    def parse_jivochat
      parsed_email = @email.body.colons_to_hash(/(nome|email|tipo|telefone|produto|mensagem).*?:/, false)
      sources = F1SalesCustom::Email::Source.all
      source = sources[0]
      source = sources[3] if (parsed_email['tipo'] || '').downcase.include?('seminovos')

      {
        source: {
          name: source[:name],
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
