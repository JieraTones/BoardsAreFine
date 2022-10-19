module BoardGames

  module CombineValues
    extend self

    def combine_strings_with_newline(values)
      values.map(&:strip).reject(&:empty?).join("\n")
    end

    def first_non_default(values, default:)
      non_defaults = values.select { |e| e != default }
      (non_defaults + [default]).first
    end

    def hardcode(_, the_value:)
      the_value
    end

    # NOTE: the last value for a given hash key will "win"
    def hash_union(values)
      values \
        .select { |e| e.is_a?(Hash) }
        .inject({}) { |a, b| a.merge(b) }
    end

    def list_union(values)
      values \
        .flatten
        .compact
        .uniq
        .sort
    end

    def min_value(values)
      values.compact.min
    end

    def status_map(values)
      all_keys = values.map(&:keys).flatten.compact.uniq

      Hash[
        all_keys.map { |key|
          list = values.map { |h| h[key] }.compact.uniq
          [ key, list.join(" + ") ]
        }
      ]
    end

    def strictest_setting(values, strictest_first:)
      valid_settings = strictest_first.flatten.intersection( values.flatten )
      valid_settings.first || strictest_first.first
    end

  end

end
