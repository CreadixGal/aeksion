import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "email"]

  connect() { }

  passwordValidation(event) {
    this.characterCount(event, this.passwordTarget)
  }

  emailValidation(event) {
    let emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
    let target = this.emailTarget
    if (target) {
      target.addEventListener('keyup', () => {
        if (!target.value.match(emailRegex)) {
          this.containsGray900(target)
          this.containsGreen900(target)
          this.errorClasses(target)
        } else {
          this.containsRed900(target)
          this.successClasses(target)
        }
      })
    }
  }


  characterCount(event, dataTarget) {
    let target = dataTarget
    if (target) {
      target.addEventListener('keyup', () => {
        if (target.value.length < 6 || target.value.length > 50) {
          this.containsGray900(target)
          this.containsGreen900(target)
          this.errorClasses(target)
        } else {
          this.containsRed900(target)
          this.successClasses(target)
        }
      })
    }
  }

  errorClasses(target) {
    target.classList.add('text-red-900', 'border-red-500', 'dark:text-red-700', 'dark:border-red-600', 'dark:focus:border-red-500', 'focus:border-red-600')
  }

  successClasses(target) {
    target.classList.add('text-green-900', 'border-green-500', 'dark:text-green-700', 'dark:border-green-600', 'dark:focus:border-green-500', 'focus:border-green-600')
  }

  containsGray900(target) {
    if (target.classList.contains('text-gray-900')) {
      target.classList.remove('text-gray-900', 'border-gray-300', 'dark:text-white', 'dark:border-gray-600', 'dark:focus:border-blue-500', 'focus:border-blue-600')
    }
  }

  containsGreen900(target) {
    if (target.classList.contains('text-green-900')) {
      target.classList.remove('text-green-900', 'border-green-500', 'dark:text-green-700', 'dark:border-green-600', 'dark:focus:border-green-500', 'focus:border-green-600')
    }
  }

  containsRed900(target) {
    if (target.classList.contains('text-red-900')) {
      target.classList.remove('text-red-900', 'border-red-500', 'dark:text-red-700', 'dark:border-red-600', 'dark:focus:border-red-500', 'focus:border-red-600')
    }
  }
}