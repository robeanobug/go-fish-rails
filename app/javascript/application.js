// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './initializers/honeybadger'
import './initializers/turbo_confirm.js'
import './initializers/frame_missing_handler.js'
import './initializers/before_morph_handler.js'
