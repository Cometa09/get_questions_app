// Entry point for the build script in your package.json
// import * as bootstrap from "bootstrap"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "@hotwired/turbo-rails"

import '@popperjs/core'
import 'bootstrap/js/dist/dropdown'

Rails.start()
Turbolinks.start()

