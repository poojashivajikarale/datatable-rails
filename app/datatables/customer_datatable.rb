class CustomerDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
       id: { source: "Customer.id", cond: :eq },
       first_name: { source: "Customer.first_name", cond: :like },
       last_name: { source: "Customer.last_name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        id: record.id,
        first_name: record.first_name,
        last_name: record.last_name
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Customer.all
  end

end
