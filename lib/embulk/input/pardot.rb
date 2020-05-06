require 'time'
require_relative 'object/wrapper_factory'

module Embulk
  module Input

    class Pardot < InputPlugin
      Plugin.register_input("pardot", self)

      def self.transaction(config, &control)
        # configuration code:
        task = {
            "user_name" => config.param("user_name", :string), # string, required
            "password" => config.param("password", :string), # string, required
            "user_key" => config.param("user_key", :string), # string, required
            "object" => config.param("object", :string), # string, required
            "from_datetime" => config.param("from_datetime", :string, default: nil),
            "columns" => config.param("columns", :array, default: []),
        }
        columns = []
        if task["columns"].size > 0 then
          task["columns"].each_with_index do |column, i|
            columns << Column.new(i, column['name'], column['type'].to_sym)
          end
        else
          Embulk.logger.info "Query profile"
          wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"]
          fields = wrapper.get_profile()
          fields.each_with_index do |field, i|
            columns << Column.new(i, field[:name], field[:type])
          end
        end
        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        task_reports = yield(task, columns, count)
        task_report = task_reports.first
        next_to_date = Time.parse(task_report[:to_datetime])
        next_config_diff = {from_datetime: next_to_date.to_s}
        return next_config_diff
      end

      # TODO
      # def self.guess(config)
      #   sample_records = [
      #     {"example"=>"a", "column"=>1, "value"=>0.1},
      #     {"example"=>"a", "column"=>2, "value"=>0.2},
      #   ]
      #   columns = Guess::SchemaGuess.from_hash_records(sample_records)
      #   return {"columns" => columns}
      # end

      def init
        # initialization code:
        @user_name = task["user_name"]
        @password = task["password"]
        @user_key = task["user_key"]
      end

      def run
        wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"]
        execution_at = Time.now
        if task["from_datetime"].nil? then
          search_criteria = {}
        else
          search_criteria = {:updated_after => Time.parse(task["from_datetime"]).strftime("%Y-%m-%d %H:%M:%S")}
        end
        rows = wrapper.query(search_criteria, Embulk.logger)

        rows.each do |row|
          result = []
          schema.each do |column|
            if not row.has_key?(column.name) then
              result << nil
            elsif row[column.name].nil? then
              result << nil
            else
              begin
                case column.type
                when :boolean then
                  result << row[column.name].downcase == "1"
                when :timestamp then
                  if row[column.name].size > 10 then
                    result << Time.strptime(row[column.name], "%Y-%m-%d %H:%M:%S").to_i
                  else
                    result << Time.strptime(row[column.name], "%Y-%m-%d").to_i
                  end
                when :double then
                  result << row[column.name].to_f
                else
                  result << row[column.name]
                end
              rescue
                Embulk.logger.info "error occured"
                result << nil
              end
            end
          end
          page_builder.add(result)
        end
        page_builder.finish

        task_report = {to_datetime: execution_at}
        return task_report
      end
    end

  end
end
