module RegalBird
  module Messaging

    # Deploys messages to delivery trucks by address.
    class Office

      def initialize(work_lorry, return_lorry)
        @work_lorry = work_lorry
        @return_lorry = return_lorry
      end

      def serve_letter(tag, decl)
        work_lorry.serve(letter_destination(tag, decl))
      end

      def serve_catalog(tag, decl)
        work_lorry.serve(catalog_destination(tag, decl))
        return_lorry.serve(catalog_return_destination(tag, decl))
      end

      def drop(outgoing_mail)
        if outgoing_mail.address.return?
          if outgoing_mail.address.letter?
            drop_letter_return(outgoing_mail)
          else
            drop_catalog_return(outgoing_mail)
          end
        else
          drop_letter(outgoing_mail)
        end
      end

      private

      def drop_catalog_return(mail)
        return_lorry.mail(mail)
      end

      def drop_letter(mail)
        work_lorry.mail(mail)
      end

      def drop_letter_return(mail)
        return_lorry.serve(letter_return_destination(mail.address))
        return_lorry.mail(mail)
      end


      def catalog_destination(tag, decl)
        Destination.new(
          "#{tag}-#{decl.recipient}-work",
          {
            routing_key: "#{tag}.#{decl.recipient}"
          },
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-max-length" => 1
            }
          }
        )
      end

      def catalog_return_destination(tag, decl)
        Destination.new(
          "#{tag}-#{decl.recipient}-retry",
          {
            arguments: {
              tag => decl.recipient
            }
          },
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-dead-letter-exchange" => work_lorry.name,
              "x-message-ttl"          => decl.interval,
              "x-max-length"           => 1,
              "x-match"                => "all"
            }
          }
        )
      end

      def letter_destination(tag, decl)
        Destination.new(
          "#{tag}-#{decl.care_of}-#{decl.recipient}-work",
          {
            routing_key: "#{tag}.#{decl.recipient}"
          },
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true
          }
        )
      end

      def letter_return_destination(address)
        ttl = address.headers.fetch("retry-wait")
        Destination.new(
          "retry-#{ttl}", # we really want "#{tag}-retry-#{ttl}", but we settled for now because tag is unavailable.
          {
            arguments: {
              "retry-wait" => ttl
            }
          },
          {
            exclusive:   false,
            auto_delete: true,
            durable:     false, # should this be true?  We don't want to lose failed
            arguments:   {
              "x-dead-letter-exchange" => work_lorry.name,
              "x-message-ttl"          => ttl,
              "x-expires"              => ttl * 2,
              "x-match"                => "all"
            }
          }
        )
      end

      attr_reader :work_lorry, :return_lorry

    end

  end
end