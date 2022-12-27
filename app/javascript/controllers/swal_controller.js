import { Controller } from "@hotwired/stimulus"
import  Swal  from  "sweetalert2"

export default class extends Controller {
  static values = {
    name: String,
  }
  connect() { }

  single(e) {
    e.preventDefault()
    console.log(this.nameValue)
    Swal.fire({
      title: `Estás seguro de eliminar ${this.nameValue}?`,
      text: `Esta acción no se puede deshacer`,
      icon: 'warning',
      buttonsStyling: false,
      customClass: {
        confirmButton: 'inline-block px-6 py-2.5 mr-2 bg-yellow-500 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-yellow-600 hover:shadow-lg focus:bg-yellow-600 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-yellow-700 active:shadow-lg transition duration-150 ease-in-out',
        cancelButton: 'inline-block px-6 py-2.5 ml-2 bg-red-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-red-700 hover:shadow-lg focus:bg-red-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-red-800 active:shadow-lg transition duration-150 ease-in-out'
      },
      showCancelButton: true,
      confirmButtonText: 'Eliminar',
      cancelButtonText: 'Cancelar',
    }).then((result) => {
      if (result.isConfirmed) this.element.parentElement.requestSubmit()
    })
  }
}