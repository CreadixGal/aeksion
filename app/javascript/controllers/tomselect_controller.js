import TomSelect from "tom-select"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['product', 'zone']
  connect() {}

  nestedProducts() {
    new TomSelect(this.productTarget, {
      plugins: {
        remove_button:{
          title:'Remove this item',
        }
      },
      placeholder: "Añadir",
      hideSelected: true,
      maxItems: 1,
      onDelete: function(values) {
        return confirm(values.length > 1 ? 'Seguro que quiere quitar ' + values.length + ' items?' : 'Seguro que quieres quitar el producto?');
      }
    });
  }

  nestedZones() {
    new TomSelect(this.zoneTarget, {
      plugins: {
        remove_button:{
          title:'Remove this item',
        }
      },
      placeholder: "Añadir",
      hideSelected: true,
      maxItems: 1,
      onDelete: function(values) {
        return confirm(values.length > 1 ? 'Seguro que quiere quitar ' + values.length + ' items?' : 'Seguro que quieres quitar la zona?');
      }
    });
  }
}
