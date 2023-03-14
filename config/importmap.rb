# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "sweetalert2", to: "https://ga.jspm.io/npm:sweetalert2@11.6.16/dist/sweetalert2.all.js"
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
pin "tom-select", to: "https://ga.jspm.io/npm:tom-select@2.1.0/dist/js/tom-select.complete.js"
pin "quill-emoji", to: "https://ga.jspm.io/npm:quill-emoji@0.2.0/dist/quill-emoji.js"
pin "buffer", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0/nodelibs/browser/buffer.js"
pin "quill", to: "https://ga.jspm.io/npm:quill@1.3.7/dist/quill.js"
