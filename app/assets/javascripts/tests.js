$(document).on('turbolinks:load', function(){
  $("table[id='tests_datatable']").each(function(){
    $(this).DataTable({
      destroy: true,
      processing: true,
      serverSide: true,
      ajax: $(this).data('url'),
      "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.15/i18n/Portuguese-Brasil.json"
      },

      columns: [
        {
          width: "5%",
          className: "",
          searchable: true,
          orderable: true
        },
        {
          width: "10%",
          className: "",
          searchable: true,
          orderable: true
        },
        {
          width: "60%",
          className: "",
          searchable: true,
          orderable: true
        },
        {
          width: "10%",
          className: "text-center",
          searchable: false,
          orderable: false
        },
        {
          width: "5%",
          className: "text-center",
          searchable: false,
          orderable: false
        },
        {
          width: "5%",
          className: "text-center",
          searchable: false,
          orderable: false
        },
        {
          width: "5%",
          className: "text-center",
          searchable: false,
          orderable: false
        },
      ],
      // order: [[1, 'asc']]

    });
  });
});
