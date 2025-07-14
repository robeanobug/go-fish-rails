import consumer from "./consumer"
import { Controller } from "@hotwired/stimulus"

consumer.subscriptions.create({channel: "GameChannel", id: document.getElementById('game_id').dataset.id}, {
  connected() {
    console.log('Connected to Actioncable')
  },

  disconnected() {
    console.log('Disconnected from Actioncable')
  },

  received(data) {
    window.location.reload()
  }
});

// export default class extends Controller {
//   static targets = ["game"];
//   connect() {
//     this.subscription = consumer.subscriptions.create({
//       channel: "GameChannel",
//       id: this.data.get("id"),
//     },
//     {
//       connected: this._connected.bind(this),
//       disconnected: this._disconnected.bind(this),
//       received: this._received.bind(this),
//     });
//   }
//   _connected() {}
//   _disconnected() {}
//   _received(data) {
//     window.location.reload()
//   }
// }