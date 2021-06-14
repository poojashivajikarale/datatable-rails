$ ->
  $('#customers-datatable').dataTable
    processing: true
    serverSide: true
    ajax:
      url: $('#customers-datatable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'first_name'}
      {data: 'last_name'}
    ]
