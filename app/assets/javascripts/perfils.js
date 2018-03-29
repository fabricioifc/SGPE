var dataTable = null;

document.addEventListener("turbolinks:before-cache", function() {
  if (dataTable !== null) {
    dataTable.destroy();
    dataTable = null;
  }
});

document.addEventListener("turbolinks:load", function() {

  $('#multi').multiselect({
    includeSelectAllOption: true,
    includeSelectAllIfMoreThan: 5,
    maxHeight: 350,
    buttonWidth: '100%',
    enableFiltering: true,
    dropLeft: true,
    selectAllText: 'Selecionar todos',
    nonSelectedText: 'Nenhum item selecionado',
    nSelectedText: ' itens selecionados',
    allSelectedText: ' Todos foram selecionados',
    enableCaseInsensitiveFiltering: true,
    filterBehavior: 'text'
  });

  var dataTableId = "table[id='perfils_datatable']";

  $(dataTableId).each(function(){
    dataTable = $(this).DataTable({
      responsive: true,
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
          className: "text-center",
          searchable: true,
          orderable: true
        },
        {
          width: "70%",
          className: "",
          searchable: true,
          orderable: true
        },
        {
          width: "10%",
          className: "text-center",
          searchable: true,
          orderable: true
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
