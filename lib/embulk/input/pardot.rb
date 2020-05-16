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
            "from_date" => config.param("from_date", :string, default: nil),
            "skip_columns" => config.param("skip_columns", :array, default: []),
            "columns" => config.param("columns", :array, default: []),
            "execution_at" => Time.now,
        }
        if not task["from_date"].nil? then
          tz = TZInfo::Timezone.get(task["timezone"])
          task["updated_after"] = tz.to_local(Time.parse(task["from_date"])).strftime("%Y-%m-%d %H:%M:%S")
        end

        counts = get_counts(task)
        columns = task["columns"].size > 0 ? create_from_config(task) : create_from_profile(task)
        resume(task, columns, counts / 200 + 1, &control)
      end

      def self.resume(task, columns, count, &control)
        yield(task, columns, count)
        next_config_diff = {from_date: task["execution_at"].to_s}
        return next_config_diff
      end

      def self.get_counts(task)
        wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"], Embulk.logger
        counts, rows = wrapper.query({:updated_after => task["updated_after"], :limit => 1}, Embulk.logger)
        Embulk.logger.info "#{counts} records."
        counts
      end

      def self.create_from_config(task)
        task["columns"].map.with_index { |column, i| Column.new(i, column['name'], column['type'].to_sym) }
      end

      def self.create_from_profile(task)
        Embulk.logger.info "Query profile"
        wrapper = WrapperFactory.create task["object"], task["user_name"], task["password"], task["user_key"], Embulk.logger
        fields = wrapper.get_profile()
        if not task["skip_columns"].nil? then
          fields = filter_fields(fields, task["object"], task["skip_columns"])
        end
        fields.map.with_index { |field, i| Column.new(i, field[:name], field[:type]) }
      end

      def self.filter_fields(fields, object, skip_columns)
        skip_columns.each do | skip_column |
          if skip_column.has_key?("ignore") and skip_column["ignore"].count(object) then
            Embulk.logger.info "pattern '#{skip_column["pattern"]}' is ignored."
            next
          end
          fields = fields.select {|field| not /^#{skip_column["pattern"]}$/.match(field[:name])}
        end
        fields
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
        @object = task["object"]
        @updated_after = task["updated_after"]
        @offset = index * 200 # 200 is maxsize of Pardot query API
      end

      def run
        wrapper = WrapperFactory.create @object, @user_name, @password, @user_key, Embulk.logger
        search_criteria = {:offset => @offset, :updated_after => @updated_after}
        counts, rows = wrapper.query(search_criteria, Embulk.logger)
        rows.each do |row|
          result = schema.map { |column| evaluate_column(column, row) }
          page_builder.add(result)
        end
        page_builder.finish

        task_report = {}
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
          Embulk.logger.info "#{column.name}:#{row[column.name]} is replaced by null."
          return nil
        end
      end
    end
  end
end
