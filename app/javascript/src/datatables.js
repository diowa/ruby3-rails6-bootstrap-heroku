require('datatables.net')(window, $)
require('datatables.net-bs5')(window, $)
require('datatables.net-buttons-bs5')(window, $)
require('datatables.net-responsive-bs5')(window, $)
require('datatables.net-select-bs5')(window, $)

document.addEventListener('turbolinks:load', function () {
  $('#member-table').DataTable({ responsive: true })
})
