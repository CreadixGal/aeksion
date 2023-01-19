import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal']
  
  fire() {
    let modalController = this.application.getControllerForElementAndIdentifier(
                            this.modalTarget, 
                            'modal'
                          )
    console.log(modalController)

    modalController.open()
  }
}