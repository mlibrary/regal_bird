module RegalBird
  module Messaging

    # Builds mailboxes for addresses.
    class Mailboxes

      def initialize(district)
        @district = district
      end

      attr_reader :district

      def name_normalize(name)
        # This needs to go on the calling class, MAYBE
        # leaning more towards doing it all here
        #   the key being to only have it in one place, obviously
        # Should we be doing this on routing keys as well?
        name.downcase.gsub("::", "_")
      end

      def catalog(recipient)
        {
          name: "#{district.catalog_tag}-#{recipient}-work",
          bind_opts: {
            routing_key: "#{district.catalog_tag}.#{recipient}"
          },
          channel_opts: {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-max-length" => 1
            }
          }
        }
      end

      def catalog_return(recipient, interval)
        {
          name: "#{district.catalog_tag}-#{recipient}-retry",
          bind_opts: {
            arguments: {
              district.catalog_tag => recipient
            }
          },
          channel_opts: {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-dead-letter-exchange" => "#{district.name}-work",
              "x-message-ttl"          => interval,
              "x-max-length"           => 1,
              "x-match"                => "all"
            }
          }
        }
      end

      # This recipient needs to be step_class + state
      def regular(recipient, care_of)
        {
          name: "#{district.regular_tag}-#{care_of}-#{recipient}-work",
          bind_opts: {
            routing_key: "#{district.regular_tag}.#{recipient}"
          },
          channel_opts: {
            exclusive:   false,
            auto_delete: false,
            durable:     true
          }
        }
      end

      def regular_return(ttl = 1000)
        {
          name: "#{district.regular_tag}-retry-#{ttl}",
          bind_opts: {
            arguments: {
              "retry-wait" => ttl
            }
          },
          channel_opts: {
            exclusive:   false,
            auto_delete: true,
            durable:     false, # should this be true?  We don't want to lose failed nme
            arguments:   {
              "x-dead-letter-exchange" => "#{district.name}-work",
              "x-message-ttl"          => ttl,
              "x-expires"              => ttl * 2,
              "x-match"                => "all"
            }
          }
        }
      end

    end

  end
end