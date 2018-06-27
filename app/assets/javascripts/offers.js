var dataTable = null;

document.addEventListener("turbolinks:before-cache", function() {
  if (dataTable !== null) {
    dataTable.destroy();
    dataTable = null;
  }
});

$(document).on('click', '#add-second-teacher', function(){
  $.showSecondUser(true);
});

document.addEventListener("turbolinks:load", function() {
  
  // Habilitar ou não o segundo professor
  $.showSecondUser($('#add-second-teacher').data('show'));
  
  var dataTableId = "table[id='offers_datatable']";

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
      order: [[ 0, "desc" ], [3, 'asc']],

      columns: [
        {
          width: "10%",
          className: "text-center",
          searchable: true,
          orderable: true
        },
        {
          width: "7%",
          className: "text-center",
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
          width: "40%",
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


$.showSecondUser = function(show) {
  if (show) {
    $('.teacher_2').css('display', 'table-cell');
    $('.teacher_1').css('width', '15%');
    $('#add-second-teacher').remove();   
  } else {
    $('.teacher_2').css('display', 'none');
  }
}