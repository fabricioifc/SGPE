// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require select2
// require select2-full
//= require dropdown
// require bootstrap
//= require datatables
//= require datatables/dataTables.bootstrap
//= require tinymce
//= require cocoon
//= require summernote
//= require_tree .

$(function() {
  $(document.body).off('click', 'nav.pagination a');
  $(document.body).on('click', 'nav.pagination a', function(e) {
    e.preventDefault();
    var loadingHTML = "<div class='loading'>Carregando...</div>";
    $("table.datatable").html(loadingHTML).load($(this).attr("href"));
    return false;
  });
});

document.addEventListener("turbolinks:load", function() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote();
  });
});
