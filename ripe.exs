defmodule HyperModel do
  defmacro __using__([]) do
    IO.inspect "using whatever"

    quote do
      Record.deffunctions [attributes: [], errors: [], validations: []], __ENV__

      def valid?(record) do
        #TODO run thru validations list
      end

      defoverridable [valid?: 1]


      def add_error(record, field, error) do
        field_error = ListDict.get(record.errors, field, "")
        record.errors( ListDict.merge record.errors, [{field, field_error}] )
      end

      def clear_errors(record) do
        record.errors([])
      end


      def validates_inclusion(record, field, options, condition) do
        if apply(condition, [record]) do
          validates_inclusion(record, field, options)
        end
      end


      def validates_inclusion(record, field, options) do
        error_message = "does not contain #{Enum.join options[:in], ", "}"
        unless :lists.member(record.attributes[field], options[:in]) do
          add_error(record, field, error_message)
        end
      end


      def validates_length(record, field, options, condition) do
        if apply(condition, [record]) do
          validates_length(record, field, options)
        end
      end


      def validates_length(record, field, options) do
        if options[:message] do
          min_message = max_message = options[:message]
        else
          min_message = "must be more than #{options[:min]}"
          max_message = "must be less than #{options[:max]}"
        end

        cond do
          is_binary(record) ->
            if options[:max] && size(record.attributes[field]) > options[:max] do
              add_error(record, field, max_message)
            end
            if options[:min] && size(record.attributes[field]) < options[:min] do
              add_error(record, field, min_message)
            end

          is_list(record) ->
            if options[:max] && length(record.attributes[field]) > options[:max] do
              add_error(record, field, max_message)
            end
            if options[:min] && length(record.attributes[field]) < options[:min] do
              add_error(record, field, min_message)
            end

          true ->
            {:error, :unsupported_data_type}
        end
      end

    end
  end
end


defmodule User do
  use HyperModel
end
