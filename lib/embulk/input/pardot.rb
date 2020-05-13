require 'time'
require 'tzinfo'
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
            "timezone" => config.param("timezone", :string), #string, required
            "updated_after" => config.param("updated_after", :string, default: nil), # string
            "from_date" => config.param("from_date", :string, default: nil),
            "skip_columns" => config.param("skip_columns", :array, default: []),
            "columns" => config.param("columns", :array, default: []),
        }
        columns = task["columns"].size > 0 ? create_from_config(task) : create_from_profile(task)
        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        task_reports = yield(task, columns, count)
        task_report = task_reports.first
        next_to_date = Time.parse(task_report[:to_date])
        next_config_diff = {from_date: next_to_date.to_s}
        return next_config_diff
      end

      def self.create_from_config(task)
        return task["columns"].map.with_index { |column, i| Column.new(i, column['name'], column['type'].to_sym) }
      end

      def self.create_from_profile(task)
        Embulk.logger.info "Query profile"
        wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"], Embulk.logger
        fields = wrapper.get_profile()
        if not task["skip_columns"].nil? then
          task["skip_columns"].each do | skip_column |
            fields = fields.select {|field| not /#{skip_column["pattern"]}/.match(field[:name])}
          end
        end
        return fields.map.with_index { |field, i| Column.new(i, field[:name], field[:type]) }
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
        wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"], Embulk.logger
        execution_at = Time.now
        search_criteria = {}
        if not task["from_date"].nil? then
          tz = TZInfo::Timezone.get(task["timezone"])
          search_criteria[:updated_after] = tz.to_local(Time.parse(task["from_date"])).strftime("%Y-%m-%d %H:%M:%S")
        end
        if not task["updated_after"].nil? then
          search_criteria[:updated_after] = task["updated_after"]
        end
        rows = wrapper.query(search_criteria, Embulk.logger)

        rows.each do |row|
          result = schema.map { |column| evaluate_column(column, row) }
          page_builder.add(result)
        end
        page_builder.finish

        task_report = {to_date: execution_at}
        return task_report
      end


      def evaluate_column(column, row)
        if not row.has_key?(column.name) or row[column.name].nil? then
          return nil
        end

        begin
          value = row[column.name]
          case column.type
          when :boolean then
            return value.downcase == "1"
          when :timestamp then
            return value.size > 10 ? Time.strptime(value, "%Y-%m-%d %H:%M:%S").to_i : Time.strptime(value, "%Y-%m-%d").to_i
          else
            return value
          end
        rescue
          Embulk.logger.info "#{column.name}:#{row[column.name]} is relaced by null."
          return nil
        end
      end
    end
  end
end
