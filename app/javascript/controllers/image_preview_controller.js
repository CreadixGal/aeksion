import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "svg"];

  // connect() {
  //   console.log("Entrando a connect");
  //   this.previewImage();
  // }

  previewImage() {
    console.log("Entrando a previewImage");
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let svg = this.svgTarget;
    console.log(preview)
    if (input.files && input.files[0]) {
      console.log("Archivo seleccionado:", input.files[0]);
      let reader = new FileReader();
      if (svg) {
        preview.classList.remove("hidden");
        svg.classList.add("hidden");
      }

      reader.onload = (e) => {
        console.log("Imagen cargada:", e.target.result);

        preview.src = e.target.result;
        console.log(e.target.result)
      };

      reader.readAsDataURL(input.files[0]);
    } else {
      console.log("No hay archivo seleccionado");
      preview.src = "";
    }
  }
}

